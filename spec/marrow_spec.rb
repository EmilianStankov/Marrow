require File.expand_path '../spec_helper.rb', __FILE__

RSpec.configure do |config|
  config.before(:each) do
    Users.register("kolio", "kolio@abv.bg", "koliokolio")
  end
  config.after(:each) do
    @user = Users.find_by(name: "kolio")
    @user.destroy
  end
end

describe "Marrow" do
  it "allows access to the home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "allows access to registration page" do
    get '/users/register'
    expect(last_response).to be_ok
  end

  it "allows access to login page" do
    get '/users/login'
    expect(last_response).to be_ok
  end

  it "allows access to popular marrows" do
    get '/marrows/browse/popular_marrows'
    expect(last_response).to be_ok
  end

  it "allows access to all public marrows" do
    get '/marrows/browse/all_marrows'
    expect(last_response).to be_ok
  end

  it "doesn't allow access to following page without login" do
    get '/users/following'
    expect(last_response).not_to be_ok
  end

  it "doesn't allow access to news page without login" do
    get '/users/news'
    expect(last_response).not_to be_ok
  end

  it "doesn't allow commenting non-existent page without login" do
    get '/marrows/comment/kolio/spec.rb'
    expect(last_response).not_to be_ok
  end

  it "doesn't allow creating a marrow when not logged in" do
    get '/marrows/create_marrow', name: 'spec.rb', language: 'ruby', creator: 'kolio', content: 'puts baba', rating: 0, access_level: 'public'
    expect(@@user).to eq nil
    expect(last_response).not_to be_ok
  end

  describe "allows creating a marrow when logged in" do
    it "allows" do
      post '/users/login', username: "kolio", password: "koliokolio"
      post '/marrows/create_marrow', name: 'spec.rb', language: 'ruby', creator: 'kolio', content: 'puts baba', rating: 0, access_level: 'public'
      expect(@@user).to eq "kolio"
      expect(last_response).to be_ok
    end
    after(:each) do
      @marrow = Marrows.find_by(name: 'spec.rb')
      @marrow.destroy
    end
  end

  it "doesn't allow login if attempting with unregistered data" do
    post '/users/login', username: "pen40", password: "pen40pen40"
    expect(@@user).to eq nil
    expect(last_response).to be_ok
  end

  it "allows login with registered data" do
    post '/users/login', username: "kolio", password: "koliokolio"
    expect(@@user).to eq "kolio"
    expect(last_response).to be_ok
  end

  describe "allows editing a marrow" do
    it "allows" do
      get '/marrows/edit/spec.rb'
      post '/marrows/edit/spec.rb', content: "puts dqdo", access_level: 'private'
      expect(Marrows.find_by(name: 'spec.rb').content).to eq "puts dqdo"
      expect(Marrows.find_by(name: 'spec.rb').access_level).to eq "private"
      expect(last_response).to be_ok
    end
    before(:each) do
      post '/users/login', username: "kolio", password: "koliokolio"
      post '/marrows/create_marrow', name: 'spec.rb', language: 'ruby', creator: 'kolio', content: 'puts baba', rating: 0, access_level: 'public'
    end
    after(:each) do
      get '/marrows/delete/spec.rb'
    end
  end

  describe "allows deleting a marrow" do
    it "allows" do
      get '/marrows/delete/spec.rb'
      get '/marrows/spec.rb/kolio'
      expect(last_response).not_to be_ok
    end
    before(:each) do
      post '/users/login', username: "kolio", password: "koliokolio"
      post '/marrows/create_marrow', name: 'spec.rb', language: 'ruby', creator: 'kolio', content: 'puts baba', rating: 0, access_level: 'public'
    end
  end

  describe "allows following a user" do
    it "allows" do
      get '/marrows/spec.rb/kolio'
      get '/users/follow/kolio/spec.rb'
      expect(Users.find_by(name: "petko").following).to eq "kolio~#<username>#~"
      expect(last_response).to be_ok
    end
    before(:each) do
      post '/users/login', username: "kolio", password: "koliokolio"
      post '/marrows/create_marrow', name: 'spec.rb', language: 'ruby', creator: 'kolio', content: 'puts baba', rating: 0, access_level: 'public'
      Users.register("petko", "petko@abv.bg", "petkopetko")
      post '/users/login', username: "petko", password: "petkopetko"
    end
    after(:each) do
      Users.find_by(name: "petko").destroy
      post '/users/login', username: "kolio", password: "koliokolio"
      get '/marrows/delete/spec.rb'
    end
  end
end