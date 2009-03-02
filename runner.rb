#!/usr/bin/env ruby

require 'rubygems'
$:.unshift File.dirname(__FILE__) + '/sinatra/lib'
require 'sinatra'
require 'lib/rack-basic_cache'

use Rack::BasicCache

require 'lib/boot'

get '/' do
	@albums = Album.find(:all)
	@title = "Albums"
	erb :list_albums
end

get '/:album/' do
	@album = Album.find_by_id(params[:album])
	@title = @album.name
	erb :show_album
end

get '/:album/:picture/' do
	@picture = Picture.find_by_id_and_album_id(params[:picture], params[:album])
	@title = "#{@picture.name} - #{@picture.album.name}"
	erb :show_picture
end

get '/:album/:picture/m/' do
	content_type 'image/jpeg'	
	@picture = Picture.find_by_id_and_album_id(params[:picture], params[:album])
	@picture.get_max
end

get '/:album/:picture/s/' do
	@picture = Picture.find_by_id_and_album_id(params[:picture], params[:album])
	@title = "#{@picture.name} - #{@picture.album.name}"
	erb :show_picture_slideshow
end
