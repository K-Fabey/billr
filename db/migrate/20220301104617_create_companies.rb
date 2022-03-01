class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :country
      t.string :phone_number
      t.string :siren
      t.string :siret
      t.string :email
      t.string :vat_number
      t.string :bank_account
      t.string :legal_status
      t.string :capital

      t.timestamps
    end
  end
end
