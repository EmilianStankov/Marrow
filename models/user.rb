require 'sinatra/activerecord'


class User < ActiveRecord::Base
  def password
    @password ||= password_hash
  end

  def password=(new_password)
    @password = Digest::SHA1.hexdigest(new_password)
    self.password_hash = @password
  end
end