get '/marrows/create_marrow' do
  authenticate
  erb :'marrows/create_marrow'
end

post '/marrows/create_marrow' do
  Marrows.create(params[:name], params[:language], @@user, params[:content], params[:access_level])
  @marrows = Marrows.where(creator: @@user)
  erb :'marrows/list_marrows'
end

get '/marrows/list_marrows' do
  authenticate
  @marrows = Marrows.where(creator: @@user)
  erb :'marrows/list_marrows'
end

get '/marrows/:marrow' do
  authenticate
  @marrow = Marrows.find_by(name: params[:marrow])
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