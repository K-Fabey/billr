class Invoice < ApplicationRecord
  RECEIVED_STATUSES = ["received", "payment in process", "validated", "declined", "paid"]
  SENT_STATUSES = ["created", "sent", "paid", "follow_uped"]

  STATUSES = (RECEIVED_STATUSES + SENT_STATUSES).uniq

  has_one_attached :invoice_file

  belongs_to :recipient, class_name: "Company"
  belongs_to :sender, class_name: "Company"

  validates :status, presence: true, inclusion: { in: STATUSES }

  validates :issue_date, presence: true
  validates :po_number, presence: true
  validates :vat_rate, presence: true
  validates :total_wo_tax, presence: true
  validates :payment_method, presence: true
  validates :tax_amount, presence: true
  validates :total_w_tax, presence: true
  validates :payment_deadline, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_company_client_and_date,
    against: [ :status, :issue_date ],

    associated_against: {
      sender: [ :name ]
    },
      associated_against: {
      recipient: [ :name ]
    },
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
  }

  def received?(user)
    recipient == user.company
  end


end
