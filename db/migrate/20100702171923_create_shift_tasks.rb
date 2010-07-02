class CreateShiftTasks < ActiveRecord::Migration
  def self.up
    create_table :shift_tasks, :id => false do |t|
      t.boolean :on_time
      t.references :task
      t.references :shift

      t.timestamps
    end
  end

  def self.down
    drop_table :shift_tasks
  end
end
