class Tag < ActiveRecord::Base
	has_and_belongs_to_many :albums, :uniq => true

	validates_presence_of :name
	validates_uniqueness_of :name, :case_senesitive => :false
	validates_format_of :name, :with => /[a-z\.]/

	def self.find_all
		Tag.find(:all, :order => 'name ASC')
	end

	def self.find_or_create(name)
		name = tagify_name(name)

		begin
			Tag.find_by_name!(name)
		rescue
			Tag.create(:name => name)
		end
	end

	def self.tagify_name(name)
		name.
			downcase. # to lowercase
			gsub(/(-|_|\s)+/, '.'). # replace space chars
			gsub(/[^a-z\.]+/, '') # replace other chars
	end

	def update_name(name)
		name = Tag.tagify_name(name)
		
		begin
			# find tag
			new = Tag.find_by_name!(name)

			# make sure the new tag isn't this
			raise ActiveRecord::Exception if new == self
			
			# it exists, so move albums
			new.albums = new.albums | self.albums

			# delete this (old) tag
			self.destroy

			# return new album
			return new
		rescue
			# doesn't exist so update name
			self.name = name
			self.save

			# return this
			return self
		end
	end		
end
