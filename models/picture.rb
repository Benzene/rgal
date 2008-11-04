class Picture < ActiveRecord::Base
	belongs_to :album
	
	validates_presence_of :name, :filename, :hash, :album
	validates_associated :album
end