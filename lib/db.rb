require 'activerecord'

ActiveRecord::Base.establish_connection(
	:wait_timeout => 0.25,
	:timeout => 250,
	:adapter => 'sqlite3',
	:database => 'database.db'
)

ActiveRecord::Base.logger = Logger.new('db.log')

ActiveRecord::Migration.verbose = true
ActiveRecord::Migrator.migrate('lib/migrate/')
