before do
  @@user ||= nil
end

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
    if available?(params[:username], params[:email])
      Users.register(params[:username], params[:email], params[:password])
      erb :'users/registration_successful'
    else
      erb :'users/registration_fail'
    end
  end
end

get '/users/login' do
  erb :'users/login'
end

post '/users/login' do
  u = Users.find_by(name: params[:username])
  unless u == nil
    salt = u.salt
    if u.password_hash == Digest::SHA1.hexdigest(salt + params[:password])
      @@user = params[:username]
      if Marrows.exists?(creator: @@user)
        @marrows = Marrows.where(creator: @@user)
        erb :'marrows/list_marrows'
      else
        erb :'marrows/create_marrow'
      end
    else
      erb :'users/login_fail'
    end
  else
    erb :'users/login_fail'
  end
end

get '/users/logout' do
  @@user = nil
  erb :'users/login'
end

def authenticate
  redirect "/users/login" if @@user == nil
end

def get_logged_user
  user = Users.find_by(name: @@user)
end

def available?(name, email)
  u1 = Users.find_by(name: name)
  u2 = Users.find_by(email: email)
  u1 == nil and u2 == nil
end