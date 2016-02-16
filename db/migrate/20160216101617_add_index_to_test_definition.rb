class AddIndexToTestDefinition < ActiveRecord::Migration
  def change
    add_index :test_definitions, :suite_id
  end
end
