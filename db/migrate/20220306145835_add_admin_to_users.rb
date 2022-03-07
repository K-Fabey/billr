class AddAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin_config, :boolean, null: false, default: false
  end
end
