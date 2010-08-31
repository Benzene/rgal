# rGal

rGal, a web based photo gallery written in Ruby, using the Sinatra framework.
This is an experimental fork, where I have made some consequent changes to the original code. It is not yet distribution-ready, as it is aimed at my personal usage, and such, still contains some hardcoded paths and other ugly things. Be aware.

## Required Gems

* sqlite3-ruby
* dm-core
* dm-sqlite-adapter
* dm-validations
* rack (0.9.1)
* sinatra (0.9.0.4)
* rmagick
* haml
* Any markdown implementation. I use rdiscount

## Usage

* Put albums of images in the <tt>data/</tt> folder.
* Run <tt>./checker.rb</tt> which will add them to the database and generate thumbnails.
* Run <tt>./runner.rb</tt> which will setup the web interface and go to <tt>http://localhost:4567/</tt>.
