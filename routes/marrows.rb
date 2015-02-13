get '/marrows/create_marrow' do
  authenticate
  erb :'marrows/create_marrow'
end

post '/marrows/create_marrow' do
  if params[:name] == ""
    @content = params[:content]
    erb :'marrows/enter_name'
  else
    Marrows.create(
      params[:name], params[:language], @@user,
      params[:content], 0, params[:access_level]
    )
    @marrows = Marrows.where(creator: @@user)
    erb :'marrows/list_marrows'
  end
end

get '/marrows/list_marrows' do
  authenticate
  @marrows = Marrows.where(creator: @@user)
  erb :'marrows/list_marrows'
end

post '/marrows/comment/:creator/:marrow' do
  authenticate
  @marrow = Marrows.find_by(name: params[:marrow], creator: params[:creator])
  comments = @marrow.comments
  comments << params[:comment] << ", by #{@@user}" << "~#<comment>#~"
  @marrow.update(comments: comments)
  @user = get_logged_user
  erb :'marrows/view_marrow'
end

get '/marrows/by/:creator' do
  @marrows = Marrows.where(creator: params[:creator], access_level: 'public')
  @creator = params[:creator]
  erb :'marrows/by_creator'
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

get '/marrows/delete/:marrow' do
  authenticate
  m = Marrows.find_by(name: params[:marrow], creator: @@user)
  m.destroy
  @marrows = Marrows.where(creator: @@user)
  erb :'marrows/list_marrows'
end

get '/marrows/like/:marrow' do
  authenticate
  u = get_logged_user
  @marrow = Marrows.find_by(name: params[:marrow])
  @marrow.update(rating: @marrow.rating + 1)
  marrow_repr = "<name:#{@marrow.name};creator:#{@marrow.creator}>"
  if u.likes == nil
    u.update(likes: marrow_repr)
  else
    u.update(likes: u.likes << marrow_repr)
  end
  puts u.likes
  erb :'marrows/view_marrow'
end

get '/marrows/dislike/:marrow' do
  authenticate
  u = get_logged_user
  @marrow = Marrows.find_by(name: params[:marrow])
  @marrow.update(rating: @marrow.rating - 1)
  marrow_repr = "<name:#{@marrow.name};creator:#{@marrow.creator}>"
  new_likes = u.likes.sub(marrow_repr, '')
  u.update(likes: new_likes)
  puts u.likes
  erb :'marrows/view_marrow'
end

get '/marrows/browse/all_marrows' do
  @marrows = Marrows.where(access_level: 'public')
  erb :'marrows/all_marrows'
end

get '/marrows/browse/popular_marrows' do
  @marrows = Marrows.where(access_level: 'public').sort.reverse[0..50]
  erb :'marrows/popular_marrows'
end

get '/marrows/:marrow/:user' do
  @marrow = Marrows.find_by(name: params[:marrow], creator: params[:user])
  erb :'marrows/missing' if @marrow == nil
  authenticate if @marrow.access_level == 'private'
  erb :'marrows/view_marrow'
end

def get_comments(marrow)
  marrow.comments.split("~#<comment>#~")
end