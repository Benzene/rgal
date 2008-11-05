#!/usr/bin/env ruby

require 'thread'
require 'lib/boot'

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
		p = Picture.find_by_album_id_and_name(a, name)
		
		if p
			if Picture.get_hash(picture) != p.filehash
				puts "   > File changed '#{name}'"
			
				p.generate_hash
				p.save
				
				changes = changes + 1
			end
		else
			puts "   > New picture '#{name}'"
			
			p = Picture.new(name, a)
			p.save
			
			changes = changes + 1
		end
	end
	
	puts "== #{changes} change(s)"
	puts
end