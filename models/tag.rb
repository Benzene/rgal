class Tag < ActiveRecord::Base
	has_and_belongs_to_many :albums

	validates_presence_of :name
	validates_uniqueness_of :name, :case_senesitive => :false
end
