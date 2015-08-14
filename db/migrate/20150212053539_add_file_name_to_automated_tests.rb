class AddFileNameToAutomatedTests < ActiveRecord::Migration
  def change
    add_column :automated_tests, :filename, :string
  end
end
