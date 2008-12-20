require 'digest/sha1'
require 'RMagick'

class Picture < ActiveRecord::Base
	belongs_to :album
	
	validates_presence_of :name, :file, :hash, :album
	validates_associated :album
	
	before_create :generate_hash
	
	def initialize(file, album)
		super(:name => file, :file => file, :album => album)
	end
	
	def filepath
		Pathname.new("#{album.realpath}/#{file}").realpath
	end
	
	def generate_hash
		self.filehash = Picture.get_hash(filepath)
	end
	
	def self.get_hash(file)
		Digest::SHA1.hexdigest(File.open(file, 'r').read)
	end

	def thumb
		"#{album.realpath}/thumbs/th_#{file}"
	end

	def url(size)
		"/#{album.id}/#{id}/#{size}/"
	end

	def generate_thumbnail
		begin
			thumb_dir = Pathname.new("#{album.realpath}/thumbs/").realpath
		rescue
			# create thumb dir if it doesn't exist, and recreate variable
			Dir.mkdir("#{album.realpath}/thumbs/")

			thumb_dir = Pathname.new("#{album.realpath}/thumbs/").realpath
		end
		
		thumb_file = "#{thumb}"

		begin
			# resize to THUMB_X x THUMB_Y and save as quality THUMB_QUALITY
			original = Magick::ImageList.new(filepath) { self.size = "#{THUMB_X}x#{THUMB_Y}" }

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
			puts "\t** Exception while creating image from #{file}:"
			puts "\t** #{e.to_s}"
		end

		ret
	end

	def get_max
		tmp = "#{album.realpath}/thumbs/m_#{file}.jpg"

		begin
			# resize to MAX_X x MAX_Y and save as quality MAX_QUALITY
			original = Magick::ImageList.new(filepath) { self.size = "#{MAX_X}x#{MAX_Y}" }

			if original.columns < original.rows
				x = MAX_X
				y = ((x.to_f / original.columns.to_f) * original.rows.to_f).to_i
			else
				y = MAX_Y
				x = ((y.to_f / original.rows.to_f) * original.columns.to_f).to_i
			end

			thumb = original.resize(x, y)
			original.destroy! # mem leak protection
				
			thumb = thumb.crop!(Magick::CenterGravity, MAX_X, MAX_Y)
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
end