class AddUserEmailPayformSubscription < ActiveRecord::Migration
  def self.up
    add_column  :user_configs, :payform_email_subscription, :boolean, :default => true
  end

  def self.down
    remove_column :user_configs, :payform_email_subcription
  end
end
