class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :salt
      t.string :password_hash
      t.string :likes
      t.string :following
    end
  end
end
