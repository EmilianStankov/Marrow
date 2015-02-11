get '/marrows/popular_marrows' do
  @marrows = Marrows.where(access_level: 'public').sort[0..50]
  erb :'marrows/popular_marrows'
end

get '/marrows/create_marrow' do
  authenticate
  erb :'marrows/create_marrow'
end

post '/marrows/create_marrow' do
  Marrows.create(
    params[:name], params[:language], @@user,
    params[:content], 0, params[:access_level]
  )
  @marrows = Marrows.where(creator: @@user)
  erb :'marrows/list_marrows'
end

get '/marrows/list_marrows' do
  authenticate
  @marrows = Marrows.where(creator: @@user)
  erb :'marrows/list_marrows'
end

get '/marrows/:marrow' do
  @marrow = Marrows.find_by(name: params[:marrow])
  erb :'marrows/missing' if @marrow == nil
  authenticate if @marrow.access_level == 'private'
  erb :'marrows/view_marrow'
end

get '/marrows/edit/:marrow' do
  authenticate
  @marrow = Marrows.find_by(name: params[:marrow])
  erb :'marrows/edit_marrow'
end

post '/marrows/edit/:marrow' do
  @marrow = Marrows.find_by(name: params[:marrow])
  @marrow.update(content: params[:content])
  @marrow.update(access_level: params[:access_level])
  erb :'marrows/view_marrow'
end

get '/marrows/like/:marrow' do
  authenticate
  u = get_logged_user
  @marrow = Marrows.find_by(name: params[:marrow])
  @marrow.update(rating: @marrow.rating + 1)
  if u.likes == nil
    u.update(likes: [@marrow])
  else
    u.update(likes: u.likes << @marrow)
  end
  erb :'marrows/view_marrow'
end

get '/marrows/dislike/:marrow' do
  authenticate
  u = get_logged_user
  @marrow = Marrows.find_by(name: params[:marrow])
  @marrow.update(rating: @marrow.rating - 1)
  u.update(likes: u.likes - [@marrow])
  erb :'marrows/view_marrow'
end