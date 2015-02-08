get '/users/register' do
  erb :register
end

post '/users/register' do
  salt = SecureRandom.hex(8)
  u = User.new
  u.name = params[:username]
  u.email = params[:email]
  u.salt = salt
  u.password = salt + params[:password]
  puts salt + params[:password]
  puts u.password
  u.save
end

get '/users/login' do
  erb :login
end

post '/users/login' do
  u = User.find_by(name: params[:username])
  salt = u.salt
  if u.password_hash == Digest::SHA1.hexdigest(salt + params[:password])
    erb :login_successful
  else
    erb :login
  end
end