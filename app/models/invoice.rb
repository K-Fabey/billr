class Invoice < ApplicationRecord
  RECEIVED_STATUSES = ["received", "payment in process", "validated", "declined", "paid"]
  SENT_STATUSES = ["created", "sent", "paid"]

  has_one_attached :invoice_file

  belongs_to :recipient, class_name: "Company"
  belongs_to :sender, class_name: "Company"

  validates :status, presence: true, inclusion: { in: (RECEIVED_STATUSES + SENT_STATUSES).uniq }

  validates :issue_date, presence: true
  validates :po_number, presence: true
  validates :vat_rate, presence: true
  validates :total_wo_tax, presence: true
  validates :payment_method, presence: true
  validates :tax_amount, presence: true
  validates :total_w_tax, presence: true
  validates :payment_deadline, presence: true


  def received?(user)
    recipient == user.company
  end

end
