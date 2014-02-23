class CreateSuites < ActiveRecord::Migration
  def change
    create_table :suites do |t|
      t.string :project
      t.string :name
      t.string :runner
      t.string :description
      t.text   :documentation
      t.string :url
      t.string :repo

      t.timestamps
    end
  end
end
