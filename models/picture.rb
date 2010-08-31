require 'digest/sha1'
require 'RMagick'

module GalleryDB
class Picture
	def self.default_repository_name 
		:gallery
	end
	
	include DataMapper::Resource

	property :id, Serial
	property :name, String, :required => true
	property :file, String, :required => true, :length => (0..100)
	property :mtime, DateTime, :required => true
	property :ctime, DateTime, :required => true

	belongs_to :album

	def self.new_picture(file, album)
		name = file.basename.to_s
		p = new(:name => name, :file => file, :album => album, :mtime => get_mtime(file), :ctime => get_mtime(file))
		begin
			p.save
		rescue Exception => ex
			puts ex
			p.errors.each do |e|
				puts e
			end
		end
		p
	end
	
	def filename
		Pathname.new(file).basename
	end

	def fileurl
		'/static' << $app_root << album.short_path << '/' << filename
	end
	
	def generate_mtime
		self.mtime = Picture.get_mtime(file)
	end
	
	def self.get_mtime(file)
		File.mtime(file)
	end

	def thumb
		album.full_path << "/thumbs/th_#{filename}"
	end

	def thumburl
		'/static' << $app_root << album.short_path << "/thumbs/th_#{filename}"
	end

	def previous
		Picture.first(
				:conditions => ["file < ? and album_id = ?", filename.to_s, album.id],
				:order => [:file.desc])
	end

	def next
		Picture.first(
				:conditions => ["file > ? and album_id = ?", filename.to_s, album.id],
				:order => [:file.asc])
	end

	def generate_thumbnail
		thumb_dir = Pathname.new(album.full_path + '/thumbs')
		
		# create thumb dir if it doesn't exist
		unless thumb_dir.exist?
			thumb_dir.mkdir
		end
		
		thumb_file = thumb

		begin
			# resize to THUMB_X x THUMB_Y and save as quality THUMB_QUALITY
			original = Magick::ImageList.new(file) { self.size = "#{THUMB_X}x#{THUMB_Y}" }

			if original.columns < original.rows
				x = THUMB_X
				y = ((x.to_f / original.columns.to_f) * original.rows.to_f).to_i
			else
				y = THUMB_Y
				x = ((y.to_f / original.rows.to_f) * original.columns.to_f).to_i
			end

			thumb = original.resize(x, y)
			original.destroy! # mem leak protection
				
			thumb = thumb.crop!(Magick::CenterGravity, THUMB_X, THUMB_Y)
			ret = thumb.write(thumb_file) { self.quality = THUMB_QUALITY }
			thumb.destroy! # mem leak protection
		rescue Exception => e
			puts "\t** Exception while creating image from #{file.basename}:"
			puts "\t** #{e.to_s}"
		end

		ret
	end

	def get_max
		tmp = album.full_path + "/thumbs/m_#{filename}"

		begin
			# resize to MAX_X x MAX_Y and save as quality MAX_QUALITY
			original = Magick::ImageList.new(file) { self.size = "#{GalleryDB::MAX_X}x#{GalleryDB::MAX_Y}" }

			thumb = original.change_geometry!("#{GalleryDB::MAX_X}x#{GalleryDB::MAX_Y}") { |cols, rows, img| img.resize(cols, rows) }
			original.destroy! # mem leak protection

			if thumb.columns < MAX_X
				x = thumb.columns
			else
				x = MAX_X
			end

			if thumb.rows < MAX_Y
				y = thumb.rows
			else
				y = MAX_Y
			end
 
			thumb = thumb.crop!(Magick::CenterGravity, x, y)

			ret = thumb.write(tmp) { self.quality = MAX_QUALITY }
			thumb.destroy! # mem leak protection
		rescue Exception => e
			puts "\t** Exception while creating image from #{file}:"
			puts "\t** #{e.to_s}"
		end

		contents = File.open(tmp).read
		File.unlink(tmp)

		contents
	end
	
	def self.is_picture?(name)
		name =~ /^.*\.(jpg|jpeg|png|JPG|JPEG|PNG)$/i
	end
end
end
