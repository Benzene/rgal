require 'digest/sha1'

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

	def urlpath
		"/data/#{album.path}/#{file}"
	end
	
	def generate_hash
		self.filehash = Picture.get_hash(filepath)
	end
	
	def self.get_hash(file)
		Digest::SHA1.hexdigest(File.open(file, 'r').read)
	end
end