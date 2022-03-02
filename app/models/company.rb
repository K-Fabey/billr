class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :received_invoices, class_name: "Invoice", foreign_key: :recipient_id, dependent: :destroy
  has_many :sent_invoices, class_name: "Invoice", foreign_key: :sender_id, dependent: :destroy
  has_many :company_partnerships, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :siren, presence: true, uniqueness: true
  validates :siret, presence: true, uniqueness: true
  validates :address, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :phone_number, presence: true
  validates :vat_number, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :bank_account, presence: true, uniqueness: true
  validates :legal_status, presence: true
  validates :capital, presence: true

  def clients
    company_ids = company_partnerships.where(client: true).pluck(:partner_id)
    Company.where(id: company_ids)
  end

  def suppliers
    company_ids = company_partnerships.where(supplier: true).pluck(:partner_id)
    Company.where(id: company_ids)
  end
end
