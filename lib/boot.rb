BASE = 'data/'

if not File.exists?(BASE)
	Dir.mkdir(BASE)
end

# setup db
require 'lib/db'

# include models
Dir["models/*.rb"].each do |model|
	require model
end