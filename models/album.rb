class Album < ActiveRecord::Base
	has_many :pictures, :order => 'name ASC'
	validates_presence_of :name, :path
	
	def initialize(path)
		super(:path => path, :name => path)
	end
	
	def realpath
		Pathname.new("#{DATA}/#{path}").realpath
	end
end