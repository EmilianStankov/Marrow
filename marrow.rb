require 'sinatra'
require 'digest/sha1'
require 'pygments.rb'

require_relative 'models/users'
require_relative 'models/marrows'

require_relative 'routes/users'
require_relative 'routes/marrows'

set :database, {adapter: "sqlite3", database: "db.sqlite3"}