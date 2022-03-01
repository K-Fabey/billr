class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.date :issue_date
      t.string :po_number
      t.string :vat_rate
      t.string :total_wo_tax
      t.string :status
      t.date :payment_deadline
      t.date :payment_date
      t.boolean :archived
      t.string :decline_reason

      t.timestamps
    end
  end
end
