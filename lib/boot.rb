require 'pathname'
require 'rubygems'

require_relative 'config'
require_relative 'links'

module GalleryDB
### Settings

# thumbnail
# (changes to the CSS will also be needed if changing the thumbnail y)
THUMB_X = 200
THUMB_Y = 200
THUMB_QUALITY = 80

# max picture size for slideshow
MAX_X = 1600
MAX_Y = 1000
MAX_QUALITY = 100

### Do not change below

DATA_PATH = Pathname.new(File.dirname(__FILE__) + '/../data/')

unless DATA_PATH.exist?
	fail "Data path `#{DATA_PATH}' does not exist!"
end

unless DATA_PATH.directory?
	fail "Data path `#{DATA_PATH}' is not a directory!"
end

DATA = DATA_PATH.realpath

# setup db
require_relative 'db'

end
