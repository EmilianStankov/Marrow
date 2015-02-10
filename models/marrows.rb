require 'sinatra/activerecord'


class Marrows < ActiveRecord::Base
  def self.create(name, language, creator, content, access_level)
    m = Marrows.new
    m.name = name
    m.language = language
    m.creator = creator
    m.content = content
    m.access_level = access_level
    m.save
  end
end