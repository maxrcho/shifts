class AddEmailToDataEntry < ActiveRecord::Migration
  def self.up
    add_column :data_entries, :email, :string
  end

  def self.down
    remove_column :data_entries, :email
  end
end
