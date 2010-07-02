class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.references :location
      t.references :calendar
      t.references :repeating_event
      t.string :name
      t.string :type
      t.datetime :start
      t.datetime :end
      t.integer :interval
      t.boolean :interval_completed, :default => false
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
