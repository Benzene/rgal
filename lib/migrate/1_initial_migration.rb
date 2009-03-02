class InitialMigration < ActiveRecord::Migration
	def self.up
		create_table :albums, :force => true do |t|
			t.text :name
			t.text :path
			t.timestamps
		end
	
		create_table :pictures, :force => true do |t|
			t.references :album
			t.text :name
			t.text :file
			t.text :filehash, :length => 40
		end
	
		create_table :schema do |t|
			t.text :version
		end
	end
end
