module GalleryDB
class AlbumTag
	def self.default_repository_name
		:gallery
	end

	include DataMapper::Resource

	property :id, Serial

	belongs_to :album
	belongs_to :tag
end

end
