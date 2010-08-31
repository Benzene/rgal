require 'sinatra'

require_relative '../globauth/Globauth-rack'

use Rack::Lint
use Rack::ShowExceptions
#use Rack::CommonLogger
use Rack::ContentLength

use Rack::Session::Pool, :domain => '82.146.49.253', :expire_after => 60 * 60 * 24 * 30, :secure => true
use Globauth

set :env, :production
set :port, 4567
disable :run, :reload

require_relative 'runner'

map $app_root do
  run Gallery
end

