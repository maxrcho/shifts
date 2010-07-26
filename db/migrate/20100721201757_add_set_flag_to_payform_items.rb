class AddSetFlagToPayformItems < ActiveRecord::Migration
  def self.up
     add_column :payform_items, :group, :boolean, :default => false    
  end

  def self.down
    remove_column :payform_items, :group
  end
end
