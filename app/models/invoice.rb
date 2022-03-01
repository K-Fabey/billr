class Invoice < ApplicationRecord
  validates :issue_date, presence: true
  validates :po_number, presence: true
  validates :vat_rate, presence: true
  validates :total_wo_tax, presence: true
  validates :payment_method, presence: true
  validates :tax_amount, presence: true
  validates :country, presence: true
  validates :total_w_tax, presence: true
  validates :status, presence: true
  validates :payment_deadline, presence: true
  validates :payment_date, presence: true
  validates :archived, presence: true
end
