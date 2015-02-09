get '/' do
  erb :'users/login'
end

get '/users/register' do
  erb :'users/register'
end

post '/users/register' do
  if params[:username].length < 4
    erb :'users/registration_fail'
  elsif params[:password].length < 8
    erb :'users/registration_fail'
  else
    Users.register(params[:username], params[:email], params[:password])
    erb :'users/registration_successful'
  end
end

get '/users/login' do
  erb :'users/login'
end

post '/users/login' do
  u = Users.find_by(name: params[:username])
  if u != nil
    salt = u.salt
    if u.password_hash == Digest::SHA1.hexdigest(salt + params[:password])
      erb :'users/login_successful'
    else
      erb :'users/login_fail'
    end
  else
    erb :'users/login_fail'
  end
end