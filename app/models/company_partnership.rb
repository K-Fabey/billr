class CompanyPartnership < ApplicationRecord
  belongs_to :company
  belongs_to :partner, class_name: "Company"
end
