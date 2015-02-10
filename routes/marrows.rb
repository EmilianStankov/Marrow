get '/marrows/create_marrow' do
  authenticate
  erb :'marrows/create_marrow'
end

post '/marrows/create_marrow' do
  Marrows.create(params[:name], @@user, params[:content], params[:access_level])
  @marrows = Marrows.where(creator: @@user)
  erb :'marrows/list_marrows'
end

get '/marrows/list_marrows' do
  authenticate
  @marrows = Marrows.where(creator: @@user)
  erb :'marrows/list_marrows'
end