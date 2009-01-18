#!/usr/bin/env ruby

require 'lib/boot'

puts "== Checking files"
puts

Dir["#{DATA}/*"].each do |album|
	name = File.basename(album)
	puts ">> Album '#{name}'"
	
	a = Album.find_by_path(name)
	changes = 0
	
	unless a
		puts "   > New"
		a = Album.new(name)
		a.save
	end
	
	Dir["#{DATA}/#{name}/*"].each do |picture|
		name = File.basename(picture)
	
		next if name == "thumbs"

		p = Picture.find_by_album_id_and_name(a, name)
		
		if p
			if Picture.get_hash(picture) != p.filehash
				puts "   > File changed '#{name}'"
			
				p.generate_hash
				p.generate_thumbnail
				p.save
				
				changes = changes + 1
			end
		else
			puts "   > New picture '#{name}'"
			
			p = Picture.new(name, a)
			p.generate_thumbnail
			p.save
			
			changes = changes + 1
		end
	end
	
	puts "-- #{changes} change(s)"
	puts
end

puts "== Checking database integrity"
puts

albums = Album.find(:all)

for album in albums
	if album.pictures.count == 0
		puts ">> Album '#{album.name}'"
		puts "   > Empty, removing"
		Album.destroy(album)
		next
	end
end
