class CreateWorlds < ActiveRecord::Migration
  def change
    create_table :worlds do |t|
      t.string :type
      t.string :component
      t.string :version

      t.timestamps
    end
  end
end
