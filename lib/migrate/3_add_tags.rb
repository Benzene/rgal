class AddTags < ActiveRecord::Migration
	def self.up
		create_table :tags, :force => :true do |t|
			t.text :name
		end

		create_table :albums_tags, :force => :true, :id => false do |t|
			t.references :album
			t.references :tag
		end
	end
end
