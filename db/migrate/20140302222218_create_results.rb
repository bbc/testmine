class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|

      # The objects these results are associated with
      t.integer   :test_definition_id, index: true

      # Run grouping (Which captures target and world information)
      t.integer   :run_id, index: true

      # Result parent -- this would typically cache child summary results
      t.integer   :parent_id, index: true

      # Simple integer value associated with a result
      t.integer   :value

      t.string    :status
      t.text      :output
      t.timestamp :started_at
      t.timestamp :finished_at

      t.timestamps
    end
  end
end
