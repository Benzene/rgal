module GalleryDB

class Album
	def self.default_repository_name 
		:gallery
	end

	include DataMapper::Resource

	property :id, Serial
	property :name, String, :required => true
	property :path, String, :required => true
	
	has n, :pictures, :order => [:name.asc]

	has n, :tags, :through => :albumtag, :unique => true

	def self.new_album(newpath)
		name = newpath.basename.to_s
		begin
			p = new(:name => name, :path => newpath)
			puts p
			p.save
		rescue Exception => ex
			puts "Saving failed :"
			puts ex
			p.errors.each do |e|
				puts e
			end
		end
		p
	end
	
	def self.find_by_real_path(path)
		Album.first(:path => path.to_s)
	end

	def self.find_untagged
		a = Album.all( :order => [:id.desc])
		a.reject! do |al|
			not al.tags.empty?
		end
	end
	
	def short_path
		basepath = File.dirname(__FILE__).sub('/models','')
		path.sub(basepath << '/lib/..' ,'')
	end
	
	def full_path
		path
	end
end

end