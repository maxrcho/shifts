class CreateShiftDutyArchives < ActiveRecord::Migration
  def self.up
    create_table :shift_duty_archives do |t|
      t.integer :duty_id
      t.integer :user_id
      t.datetime :time_completed
      t.boolean :on_time

      t.timestamps
    end
  end

  def self.down
    drop_table :shift_duty_archives
  end
end
