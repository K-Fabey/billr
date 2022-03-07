class AddColumnToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :checkout_session_id, :string
  end
end
