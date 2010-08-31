require 'dm-core'
require 'dm-validations'

module GalleryDB

DataMapper.setup(:gallery, 'sqlite3:///home/wilya/rgal/gallery.db' )
#DataMapper.setup(:default, 'sqlite3:///home/wilya/rgal/gallery_def.db' )

# include models
require_relative '../models/album'
require_relative '../models/picture'
require_relative '../models/albumtag'
require_relative '../models/tag'

DataMapper.finalize

DataMapper::Model.raise_on_save_failure = true

end
