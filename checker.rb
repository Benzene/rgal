#!/usr/bin/env ruby

require_relative 'lib/boot'

include GalleryDB

puts "== Checking files"
puts

def process_dir(parent, a = nil)
	changes = 0

	parent.children.each do |file|
		name = file.basename.to_s
	
		# if it is a file, and we have an album, process it as a picture
		if file.file? and not a.nil? and Picture.is_picture?(name)
			p = Picture.first(:album => a , :name => name)
			
			if p
				if Picture.get_mtime(file) != p.mtime
					puts "   > File changed '#{name}'"
				
					p.generate_mtime
					p.generate_thumbnail
					p.save
					
					changes = changes + 1
				end
			else
				puts "   > New picture '#{name}'"
				
				p = Picture.new_picture(file, a)
				p.generate_thumbnail
				
				changes = changes + 1
			end
		
		# if it is a directory process it as an album
		elsif file.directory?
		
			# skip the thumbnail cache
			next if name == "thumbs"
			
			puts ">> Album '#{name}'"
		
			sub_a = Album.find_by_real_path(file)
		
			unless sub_a
				puts "   > New"
				sub_a = Album.new_album(file)

				# add tags
				unless a.nil?
					sub_a.tags << a.tags
					sub_a.tags << Tag.find_or_create(a.name)
				end
			end

			changes = process_dir(file, sub_a)
		end
	end
	
	changes
end

process_dir(DATA_PATH)

puts "== Checking database integrity"
puts

albums = repository(:gallery) {Album.all}

for album in albums
	if album.pictures.count == 0
		puts ">> Album '#{album.name}'"
		puts "   > Empty, removing"
		album.destroy
		next
	end
end

