# rGal

rGal, a web based photo gallery written in Rails, using the Sinatra framework.

## Required Gems

* sqlite3-ruby
* activerecord
* rack (0.4.0)
* sinatra (0.3.3)
* mongrel
* rmagick

## Usage

* Put albums of images in the <tt>data/</tt> folder.
* Run <tt>./checker.rb</tt> which will add them to the database and generate thumbnails.
* Run <tt>./runner.rb</tt> which will setup the web interface and go to <tt>http://localhost:4567/</tt>.
