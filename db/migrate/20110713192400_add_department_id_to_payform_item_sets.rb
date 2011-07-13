class AddDepartmentIdToPayformItemSets < ActiveRecord::Migration
  def self.up
    add_column :payform_item_sets, :department_id, :integer
  end

  def self.down
    remove_column :payform_item_sets, :department_id
  end
end
