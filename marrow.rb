require 'sinatra'

require_relative 'models/user'

require_relative 'routes/users'


set :database, {adapter: "sqlite3", database: "db.sqlite3"}