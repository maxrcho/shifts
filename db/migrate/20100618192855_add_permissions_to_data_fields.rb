class AddPermissionsToDataFields < ActiveRecord::Migration
  def self.up
    add_column :data_fields, :permissions, :string, :default => "FFF"
  end

  def self.down
    remove_column :data_fields, :permissions
  end
end
