BASE = 'data/'
ROOT = File.dirname(__FILE__) + "/../"

if not File.exists?(BASE)
	Dir.mkdir(BASE)
end

require 'lib/db'