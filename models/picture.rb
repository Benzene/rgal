require 'digest/sha1'
require 'RMagick'

class Picture < ActiveRecord::Base
	belongs_to :album
	
	validates_presence_of :name, :file, :hash, :album
	validates_associated :album
	
	before_create :generate_hash
	
	def initialize(file, album)
		name = file.basename.to_s
		super(:name => name, :file => file, :album => album)
	end
	
	def file
		album.path + read_attribute(:file)
	end
	
	def file=(file)
		write_attribute(:file, file.relative_path_from(album.path))
	end
	
	def filename
		file.basename
	end

	def fileurl
		"/data/#{album.rel_path}/#{filename}"
	end
	
	def generate_hash
		self.filehash = Picture.get_hash(file)
	end
	
	def self.get_hash(file)
		Digest::SHA1.hexdigest(File.open(file, 'r').read)
	end

	def thumb
		album.path + "thumbs/th_#{filename}"
	end

	def thumburl
		"/data/#{album.rel_path}/thumbs/th_#{filename}"
	end

	def previous
		Picture.find :first,
				:conditions => ["file < ? and album_id = ?", filename.to_s, album.id],
				:order => 'file DESC'
	end

	def next
		Picture.find :first,
				:conditions => ["file > ? and album_id = ?", filename.to_s, album.id],
				:order => 'file ASC'
	end

	def generate_thumbnail
		thumb_dir = album.path + 'thumbs'
		
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
		tmp = album.path + "thumbs/m_#{filename}.jpg"

		begin
			# resize to MAX_X x MAX_Y and save as quality MAX_QUALITY
			original = Magick::ImageList.new(file) { self.size = "#{MAX_X}x#{MAX_Y}" }

			thumb = original.change_geometry!("#{MAX_X}x#{MAX_Y}") { |cols, rows, img| img.resize(cols, rows) }
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
		name =~ /\.(jpg|jpeg|png)$/i
	end
end
