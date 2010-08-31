#!/usr/bin/env ruby

#$:.unshift File.dirname(__FILE__) + '/sinatra/lib'
require 'sinatra'

#require 'lib/rack-basic_cache'
#use Rack::BasicCache

require_relative 'lib/boot'

class Gallery < Sinatra::Base

	include GalleryDB

	set :root, File.dirname(__FILE__)
	
	before do
		if @env['rack.session']['uid'] then
			puts @env['rack.session']['uid']
		else
			redirect '/'
		end
	end
	
	get '/' do
		@tags = Tag.find_all
#		@albums = Album.find_untagged
		@albums = Album.all
		@title = "Albums"
		haml :index
	end

	get '/t/:tag/' do
		@tag = Tag.get(params[:tag])
		@title = @tag.name
		@albums = @tag.albums
		haml :show_tag
	end

	post '/t/:tag/e' do
		@tag = Tag.get(params[:tag])

		unless params[:name].nil?
			@tag = @tag.update_name(params[:name])
		end
		
		# return json
		"{id: #{@tag.id}, url: '/t/#{@tag.id}/'}"
	end

	get '/:album/' do
		@album = Album.get(params[:album])
		@title = @album.name
		haml :show_album
	end

	post '/:album/e' do
		@album = Album.get(params[:album])

		if params[:id] == 'name'
			@album.name = params[:value]
			@album.save
		end

		@album.name
	end

	get '/:album/:picture/' do
		@picture = Picture.first(:id => params[:picture], :album => {:id => params[:album]})
		@title = "#{@picture.name} - #{@picture.album.name}"
		haml :show_picture
	end

	get '/:album/:picture/m/' do
		content_type 'image/jpeg'	
		@picture = Picture.first(:id => params[:picture], :album => {:id => params[:album]})
		@picture.get_max
	end

	get '/:album/:picture/s/' do
		@picture = Picture.first(:id => params[:picture], :album => {:id => params[:album]})
		@title = "#{@picture.name} - #{@picture.album.name}"
		haml :show_picture_slideshow
	end
end

