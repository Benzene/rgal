require 'pathname'

### Settings

# thumbnail
# (changes to the CSS will also be needed if changing the thumbnail y)
THUMB_X = 200
THUMB_Y = 200
THUMB_QUALITY = 50

# max picture size for slideshow
MAX_X = 1600
MAX_Y = 800
MAX_QUALITY = 80

### Do not change below

ROOT = Pathname.new('.').realpath
DATA = Pathname.new('data/').realpath

if not File.exists?(DATA)
	Dir.mkdir(DATA)
end

# setup db
require 'lib/db'

# include models
Dir["models/*.rb"].each do |model|
	require model
end