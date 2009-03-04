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
			
end
