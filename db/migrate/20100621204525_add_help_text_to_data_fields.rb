class AddHelpTextToDataFields < ActiveRecord::Migration
  def self.up
    add_column :data_fields, :help_text, :string
  end

  def self.down
    remove_column :data_fields, :help_text
  end
end
