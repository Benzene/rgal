BASE = 'data/'

def boot
	require 'models/image'
	require 'models/album'
	require 'models/tag'

	if not File.exists?(BASE)
		Dir.mkdir(BASE)
	end

	require 'lib/db'
end