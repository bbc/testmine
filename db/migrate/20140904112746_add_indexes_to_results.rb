class AddIndexesToResults < ActiveRecord::Migration
  def change
    add_index :results, :parent_id
    add_index :results, :run_id
  end
end
