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

	def fileurl
		"/data/#{album.path}/#{file}"
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

	def thumburl
		"/data/#{album.path}/thumbs/th_#{file}"
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
			# resize to 200x200
			original = Magick::ImageList.new(filepath) { self.size = '200x200' }

			if original.columns < original.rows
				x = 200
				y = ((x.to_f / original.columns.to_f) * original.rows.to_f).to_i
			else
				y = 200
				x = ((y.to_f / original.rows.to_f) * original.columns.to_f).to_i
			end

			thumb = original.resize(x, y)
			original.destroy! # mem leak protection
				
			thumb = thumb.crop!(Magick::CenterGravity, 200, 200)
			ret = thumb.write(thumb_file) { self.quality = 50 }
			thumb.destroy! # mem leak protection
		rescue Exception => e
			puts "\t** Exception while creating image from #{file}:"
			puts "\t** #{e.to_s}"
		end

		ret
	end
end