class CreateShiftDuties < ActiveRecord::Migration
  def self.up
    create_table :shift_duties do |t|
      t.string :name
      t.integer :duty_type
      t.datetime :start
      t.datetime :end
      t.integer :interval
      t.boolean :completed, :default => false
      t.boolean :active, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :shift_duties
  end
end
