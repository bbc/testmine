class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.references :world, index: true
      t.string :owner

      t.timestamps
    end
  end
end
