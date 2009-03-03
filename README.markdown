# rGal

rGal, a web based photo gallery written in Ruby, using the Sinatra framework.

## Required Gems

* sqlite3-ruby
* activerecord
* rack (0.9.1)
* sinatra (0.9.0.4)
* mongrel
* rmagick
* haml

## Usage

* Put albums of images in the <tt>data/</tt> folder.
* Run <tt>./checker.rb</tt> which will add them to the database and generate thumbnails.
* Run <tt>./runner.rb</tt> which will setup the web interface and go to <tt>http://localhost:4567/</tt>.
