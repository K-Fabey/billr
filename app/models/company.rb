class Company < ApplicationRecord
  has_many :users
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
end
