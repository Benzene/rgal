#!/usr/bin/env ruby

require 'lib/boot'

$:.unshift File.dirname(__FILE__) + '/sinatra/lib'
require 'sinatra'


get '/' do
	@albums = Album.find(:all)
	erb :index
end