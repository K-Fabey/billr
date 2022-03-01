class Invoice < ApplicationRecord
  RECEIVED_STATUSES = ["validated", "declined", "payment in process", "paid", "received"]
  SENT_STATUSES = ["paid", "sent", "created"]
  belongs_to :recipient, class_name: "Company"
  belongs_to :sender, class_name: "Company"
  validates :issue_date, presence: true
  validates :po_number, presence: true
  validates :vat_rate, presence: true
  validates :total_wo_tax, presence: true
  validates :payment_method, presence: true
  validates :tax_amount, presence: true
  validates :total_w_tax, presence: true
  validates :status, presence: true, inclusion: { in: (RECEIVED_STATUSES + SENT_STATUSES).uniq }
  validates :payment_deadline, presence: true
end
