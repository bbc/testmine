class AddIndexToResults < ActiveRecord::Migration
  def change
    add_index :results, :test_definition_id
  end
end
