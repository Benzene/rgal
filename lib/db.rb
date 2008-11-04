require 'rubygems'
require 'activerecord'

ActiveRecord::Base.establish_connection(
	:adapter => 'sqlite3',
	:database => 'database.db'
)

ActiveRecord::Base.logger = Logger.new('db.log')

begin
	@latest = ActiveRecord::Base.connection.select_one("SELECT version FROM schema")['version'].to_i
rescue
	@latest = 0
end

Dir["lib/db_scripts/*.rb"].each do |sub|
	v = File.basename(sub).to_i
	if v > @latest
		puts ">> Running migration (#{v}) #{File.basename(sub)}"
		@latest = v
		eval(File.open(sub, 'r').read)
	end
end

puts "== Migrations up to date at version #{@latest}"