class AddSignInLimittoDeptConfig < ActiveRecord::Migration
  def self.up
    add_column :department_configs, :sign_in_limit, :integer
    
  end

  def self.down
    remove_column :department_configs, :sign_in_limit
  end
end
