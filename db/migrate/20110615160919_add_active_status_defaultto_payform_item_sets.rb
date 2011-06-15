class AddActiveStatusDefaulttoPayformItemSets < ActiveRecord::Migration
  def self.up
    change_column :payform_item_sets, :active, :boolean, :default => true
  end

  def self.down
    change_column :payform_item_sets, :active, :boolean
  end
end
