class CreateAutomatedTests < ActiveRecord::Migration
  def change
    create_table :automated_tests do |t|
      t.string :testid
      t.string :int
      t.string :name
      t.string :description
      t.string :lastrundate
      t.string :datetime
      t.boolean :pass
      t.string :lastruntext

      t.timestamps null: false
    end
  end
end
