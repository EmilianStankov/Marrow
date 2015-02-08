get 'users/register' do
  erb :register
end

post 'users/register' do
  u = User.new
  u.name = params[:username]
  u.email = params[:email]
  u.password = params[:password]
  u.save
end