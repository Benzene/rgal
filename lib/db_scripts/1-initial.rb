ActiveRecord::Schema.define do
	create_table :albums, :force => true do |t|
		t.text :name
		t.text :path
		t.timestamps
	end
	
	create_table :images, :force => true do |t|
		t.references :album
		t.text :name
		t.text :filename
		t.text :hash, :length => 32
	end
	
	create_table :schema do |t|
		t.text :version
	end
	
	execute "INSERT INTO schema VALUES(0, 1);"
end