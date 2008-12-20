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