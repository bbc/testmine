# Table for capturing hierarchical test definitions
class CreateTestDefinitions < ActiveRecord::Migration
  def change
    create_table :test_definitions do |t|
      t.string  :name              # "Scanning item"
      t.string  :node_type         # Cucumber::Feature
      t.text    :description       # "\nAs a cashier\nI want to scan an item\nSo I can demand cash"
      t.string  :file_name         # "features\/scan_items.feature"
      t.integer :line              # 1 -- line number from the file where the definition starts
 
      # Foreign keys
      t.integer  :parent_id       # What owns this test?
      t.integer  :parent_type     # What type is it?

      t.timestamps
    end
  end
end
