#!/usr/bin/env ruby

require 'lib/boot'

$:.unshift File.dirname(__FILE__) + '/sinatra/lib'
require 'sinatra'

get '/' do
	@albums = Album.find(:all)
	erb :list_albums
end

get '/:album/' do
	@album = Album.find_by_id(params[:album])
	erb :show_album
end

get '/:album/:picture/' do
	@picture = Picture.find_by_id_and_album_id(params[:picture], params[:album])
	erb :show_picture
end

get '/:album/:picture/:size/' do
	content_type 'image/jpeg'
	
	case params[:size]
	when 'm'	
		@picture = Picture.find_by_id_and_album_id(params[:picture], params[:album])
		@picture.get_max
	else
	end
end