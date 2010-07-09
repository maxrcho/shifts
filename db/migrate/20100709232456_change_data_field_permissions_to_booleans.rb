class ChangeDataFieldPermissionsToBooleans < ActiveRecord::Migration
  def self.up
		add_column :data_fields, :admin, :boolean
		add_column :data_fields, :public, :boolean
		add_column :data_fields, :private, :boolean
    remove_column :data_fields, :permissions
  end

  def self.down
		remove_column :data_fields, :admin
		remove_column :data_fields, :public
		remove_column :data_fields, :private
		add_column :data_fields, :permissions, :string, :default => "FFF"

  end
end
