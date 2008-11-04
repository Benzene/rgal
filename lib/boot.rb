require 'pathname'

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