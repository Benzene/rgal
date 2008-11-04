require 'rubygems'
require 'sqlite3'

# setup database
DB = SQLite3::Database.new("database.db")

DB.busy_timeout(5000)

begin
	DB.execute "SELECT version FROM schema LIMIT 1;" do |s|
		@latest = s[0].to_i
	end
rescue SQLite3::SQLException
	@latest = 0
end

Dir["lib/db_scripts/*.sql"].each do |sub|
	v = File.basename(sub).to_i
	if v > @latest
		puts ">> Running migration (#{v}) #{File.basename(sub)}"
		@latest = v
		DB.execute_batch File.open(sub, 'r').read
		DB.execute "UPDATE schema SET version = #{@latest};"
	end
end

puts "== Migrations up to date at version #{@latest}"