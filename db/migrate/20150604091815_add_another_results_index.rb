class AddAnotherResultsIndex < ActiveRecord::Migration
  def change
    add_index :results, [:run_id, :test_definition_id]
  end
end