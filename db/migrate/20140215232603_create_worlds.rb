class CreateWorlds < ActiveRecord::Migration
  def change
    create_table :worlds do |t|
      t.string :type
      t.string :name
      t.text   :description
      t.string :project
      t.string :component
      t.string :version

      t.timestamps
      
      t.index [:component, :version]
    end
  end
end
