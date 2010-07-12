class PayformItemsPayforms < ActiveRecord::Migration
  def self.up
    create_table :payform_items_payforms, :id => false do |t|
      t.references :payform_item
      t.references :payform
    end
  end

  def self.down
    drop_table :payform_items_payforms
  end
end
