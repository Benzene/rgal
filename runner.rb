#!/usr/bin/env ruby

require 'rubygems'
$:.unshift File.dirname(__FILE__) + '/sinatra/lib'
require 'sinatra'
require 'lib/rack-basic_cache'

use Rack::BasicCache

require 'lib/boot'

get '/' do
	@tags = Tag.find_all
	@albums = Album.find_untagged
	@title = "Albums"
	haml :index
end

get '/t/:tag/' do
	@tag = Tag.find_by_id(params[:tag])
	@title = @tag.name
	@albums = @tag.albums
	erb :show_tag
end

post '/t/:tag/e' do
	@tag = Tag.find_by_id(params[:tag])

	unless params[:name].nil?
		@tag = @tag.update_name(params[:name])
	end
	
	# return json
	"{id: #{@tag.id}, url: '/t/#{@tag.id}/'}"
end

get '/:album/' do
	@album = Album.find_by_id(params[:album])
	@title = @album.name
	haml :show_album
end

post '/:album/e' do
	@album = Album.find_by_id(params[:album])

	if params[:id] == 'name'
		@album.name = params[:value]
		@album.save
	end

	@album.name
end

get '/:album/:picture/' do
	@picture = Picture.find_by_id_and_album_id(params[:picture], params[:album])
	@title = "#{@picture.name} - #{@picture.album.name}"
	haml :show_picture
end

get '/:album/:picture/m/' do
	content_type 'image/jpeg'	
	@picture = Picture.find_by_id_and_album_id(params[:picture], params[:album])
	@picture.get_max
end

get '/:album/:picture/s/' do
	@picture = Picture.find_by_id_and_album_id(params[:picture], params[:album])
	@title = "#{@picture.name} - #{@picture.album.name}"
	haml :show_picture_slideshow
end
