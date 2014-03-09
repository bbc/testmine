class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.references :world, index: true
      t.string     :owner
      t.integer    :hive_job_id, index: true
      t.string     :target, index: true
      t.string     :status
      t.timestamp  :started_at
      t.timestamp  :finished_at

      t.timestamps
    end
  end
end
