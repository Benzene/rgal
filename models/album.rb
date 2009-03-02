class Album < ActiveRecord::Base
	has_many :pictures, :order => 'name ASC'
	validates_presence_of :name, :path
	
	def initialize(path)
		name = path.basename.to_s
		super(:path => path, :name => name)
	end
	
	def path
		DATA_PATH + read_attribute(:path)
	end
	
	def path=(path)
		write_attribute(:path, path.relative_path_from(DATA_PATH))
	end
	
	def rel_path
		read_attribute(:path)
	end
	
	def self.find_by_real_path(path)
		rel_path = path.relative_path_from(DATA_PATH)
		Album.find_by_path(rel_path.to_s)
	end
end
