class CreateMarrows < ActiveRecord::Migration
  def change
    create_table :marrows do |t|
      t.string :name
      t.string :creator
      t.string :content
      t.string :access_level
    end
  end
end
