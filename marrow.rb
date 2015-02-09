require 'sinatra'
require 'digest/sha1'

require_relative 'models/users'

require_relative 'routes/users'

set :database, {adapter: "sqlite3", database: "db.sqlite3"}