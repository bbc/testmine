class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|

      # The objects these results are associated with
      t.integer   :test_definition_id

      # Run grouping (Which captures target and world information)
      t.integer   :run_id

      # Result parent -- this would typically cache child summary results
      t.integer   :parent_id

      # Simple integer value associated with a result
      t.integer   :value

      t.string    :status
      t.text      :output
      t.timestamp :started_at
      t.timestamp :ended_at

      t.timestamps
    end
  end
end
