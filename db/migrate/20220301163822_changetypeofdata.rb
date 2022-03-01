class Changetypeofdata < ActiveRecord::Migration[6.1]
  def change
    remove_column :invoices, :total_wo_tax, :string
    remove_column :invoices, :vat_rate, :string
    remove_column :invoices, :total_w_tax, :string
    remove_column :invoices, :tax_amount, :string

    add_column :invoices, :total_wo_tax, :float
    add_column :invoices, :vat_rate, :float
    add_column :invoices, :total_w_tax, :float
    add_column :invoices, :tax_amount, :float
  end
end
