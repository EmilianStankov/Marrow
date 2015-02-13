class CreateMarrows < ActiveRecord::Migration
  def change
    create_table :marrows do |t|
      t.string :name
      t.string :creator
      t.string :language
      t.string :content
      t.integer :rating
      t.string :comments
      t.string :access_level
    end
  end
end
