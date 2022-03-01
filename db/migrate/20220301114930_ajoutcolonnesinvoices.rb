class Ajoutcolonnesinvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :payment_method, :string
    add_column :invoices, :total_w_tax, :string
    add_column :invoices, :tax_amount, :string
  end
end
