class Modifystringtobooleans < ActiveRecord::Migration[6.1]
  def change
    remove_column :company_partnerships, :client, :string
    remove_column :company_partnerships, :supplier, :string
    add_column :company_partnerships, :client, :boolean, default: false
    add_column :company_partnerships, :supplier, :boolean, default: false
  end
end
