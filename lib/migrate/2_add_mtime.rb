class AddMtime < ActiveRecord::Migration
	def self.up
		remove_column :pictures, :filehash
		add_column :pictures, :mtime, :integer, :default => 0
	end
end
