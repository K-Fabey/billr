class Ajoutforeignkeys < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :company, foreign_key: true, index: true
    add_reference :company_partnerships, :company, foreign_key: true, index: true
    add_reference :company_partnerships, :partner, foreign_key: { to_table: :companies }, index: true
    add_reference :invoices, :sender, foreign_key: { to_table: :companies }, index: true
    add_reference :invoices, :recipient, foreign_key: { to_table: :companies }, index: true
  end
end
