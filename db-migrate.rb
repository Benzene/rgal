#!/usr/bin/env ruby

require_relative 'lib/db'

require 'dm-migrations'
DataMapper.auto_migrate!(:gallery)

