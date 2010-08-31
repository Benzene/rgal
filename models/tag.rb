module GalleryDB
class Tag
	def self.default_repository_name 
		:gallery
	end

	include DataMapper::Resource

	property :id, Serial
	property :name, String, :required => true, :unique => true, :format => /[a-z\.]/
	has n, :albums, :through => :albumtag, :unique => true

	def self.find_all
		Tag.all( :order => [:name.asc] )
	end

	def self.find_or_create(name)
		name = tagify_name(name)
		Tag.first_or_create(:name => name)
	end

	def self.tagify_name(name)
		name.
			downcase. # to lowercase
			gsub(/(-|_|\s)+/, '.'). # replace space chars
			gsub(/[^a-z\.]+/, '') # replace other chars
	end

	def update_name(name)
		name = Tag.tagify_name(name)
		
		begin
			# find tag
			new = Tag.first!(:name => name)

			# make sure the new tag isn't this
			raise DataMapper::Exception if new == self
			
			# it exists, so move albums
			new.albums = new.albums | self.albums

			# delete this (old) tag
			self.destroy

			# return new album
			return new
		rescue
			# doesn't exist so update name
			self.name = name
			self.save

			# return this
			return self
		end
	end		
end
end
