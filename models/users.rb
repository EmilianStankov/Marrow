require 'sinatra/activerecord'


class Users < ActiveRecord::Base
  def password
    @password ||= password_hash
  end

  def password=(new_password)
    @password = Digest::SHA1.hexdigest(new_password)
    self.password_hash = @password
  end

  def self.register(name, email, password)
    salt = SecureRandom.hex(8)
    u = Users.new
    u.name = name
    u.email = email
    u.salt = salt
    u.password = salt + password
    u.likes = ""
    u.following = ""
    u.save
  end

  def self.destroy
    self.destroy
  end
end