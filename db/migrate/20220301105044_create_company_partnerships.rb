class CreateCompanyPartnerships < ActiveRecord::Migration[6.1]
  def change
    create_table :company_partnerships do |t|
      t.string :client
      t.string :supplier

      t.timestamps
    end
  end
end
