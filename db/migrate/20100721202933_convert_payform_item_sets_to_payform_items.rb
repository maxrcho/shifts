class ConvertPayformItemSetsToPayformItems < ActiveRecord::Migration
  def self.up
    for p_i_s in PayformItemSet.all
      p_i = PayformItem.new
      
    end
  end

  def self.down
    for p_i in PayformItem.group
      
    end
  end
end
