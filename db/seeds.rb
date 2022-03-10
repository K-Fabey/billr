# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'
require 'faker'

puts "Destroying all companies !"
CompanyPartnership.destroy_all
Company.destroy_all
puts "creating new companies and invoices..."

le_wagon = Company.create!(name: "Le Wagon",
                        siren: "794949917",
                        siret: "79494991700023",
                        address: "24 RUE LOUIS BLANC",
                        city: "Paris",
                        country: "France",
                        phone_number: "+33 01 23 45 67 89",
                        vat_number: "FR03794949917",
                        email: "contact@lewagon.fr",
                        bank_account: "FR12 1234 5678 1234 5678 1234 567",
                        legal_status: "SAS",
                        capital: "1000 €")

office_depot = Company.create!(name: "Office Depot",
                        siren: "402254437",
                        siret: "40225443700690",
                        address: "126 AVENUE DU POTEAU",
                        city: "SENLIS",
                        country: "France",
                        phone_number: "+33 01 23 45 67 89",
                        vat_number: "FR00402254437",
                        email: "magasin-paris11@officedepot.com",
                        bank_account: "FR12 4444 5678 1234 5678 1234 567",
                        legal_status: "SAS",
                        capital: "70 668 261 €")

orange = Company.create!(name: "Orange",
                        siren: "380129866",
                        siret: "38012986648625",
                        address: "111 QUAI DU PRESIDENT ROOSEVELT",
                        city: "ISSY-LES-MOULINEAUX",
                        country: "France",
                        phone_number: "+33 01 65 48 87 80",
                        vat_number: "FR89380129866",
                        email: "factures-recues@orange.com",
                        bank_account: "FR12 5555 5678 1234 5678 1234 567",
                        legal_status: "SA",
                        capital: "10 640 226 396 €")

CompanyPartnership.create!(company: le_wagon, partner: office_depot, supplier: true)
CompanyPartnership.create!(company: le_wagon, partner: orange, client: true)

20.times do
  partner = Company.new(
    name: Faker::Company.name,
    siren: Faker::Number.number(digits: 9),
    siret: Faker::Number.number(digits: 14),
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    country: Faker::Address.country,
    phone_number: Faker::Number.number(digits: 10),
    vat_number: "FR#{Faker::Number.number(digits: 11)}",
    email: Faker::Internet.email,
    bank_account: "FR#{Faker::Number.number(digits: 25)}",
    legal_status: Faker::Company.type,
    capital: "#{Faker::Number.number(digits: 6)} €"
  )
  partner.save!
  CompanyPartnership.create!(company: le_wagon, partner: partner, client: true)
  3.times do
    total_without_tax = Faker::Number.decimal(l_digits: 4)
    tax_amount = 0.2 * total_without_tax
    status = Invoice::SENT_STATUSES.sample
    payment_date = Faker::Date.between(from: '2022-03-08', to: '2022-03-22') if status == "paid"
    declined_reasons = ["pas de tva", "pas de total HT", "adresse manquante"]
    declined_reason = declined_reasons.sample if status == "declined"
    Invoice.create!(
      sender: le_wagon,
      recipient: partner,
      issue_date: Faker::Date.between(from: '2022-03-01', to: '2022-03-10'),
      po_number: Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3),
      vat_rate: 20,
      total_wo_tax: total_without_tax,
      status: status,
      payment_deadline: Faker::Date.between(from: '2022-03-15', to: '2022-03-22'),
      payment_date: payment_date,
      archived: false,
      decline_reason: declined_reason,
      payment_method: "virement SEPA",
      total_w_tax: tax_amount + total_without_tax,
      tax_amount: tax_amount
    )
  end
end
invoicefixe1 = Invoice.create!(
      sender: le_wagon,
      recipient: orange,
      issue_date: Faker::Date.between(from: '2022-03-01', to: '2022-03-03'),
      po_number: 'ORANGE2349',
      vat_rate: 20,
      total_wo_tax: 70000,
      status: 'created',
      payment_deadline: '2022-03-05',
      payment_date: '2022-03-03',
      archived: false,
      decline_reason: "",
      payment_method: "virement SEPA",
      total_w_tax: 84000,
      tax_amount: 14000
    )
file2 = File.open('app/assets/images/INV-004863-Orange.pdf')
invoicefixe1.invoice_file.attach(io: file2, filename: 'invoice.pdf', content_type: 'application/pdf')

20.times do
  partner = Company.new(
    name: Faker::Company.name,
    siren: Faker::Number.number(digits: 9),
    siret: Faker::Number.number(digits: 14),
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    country: Faker::Address.country,
    phone_number: Faker::Number.number(digits: 10),
    vat_number: "FR#{Faker::Number.number(digits: 11)}",
    email: Faker::Internet.email,
    bank_account: "FR#{Faker::Number.number(digits: 25)}",
    legal_status: Faker::Company.type,
    capital: "#{Faker::Number.number(digits: 6)} €"
  )
  partner.save!
  CompanyPartnership.create!(company: le_wagon, partner: partner, supplier: true)
  3.times do
    total_without_tax = Faker::Number.decimal(l_digits: 4)
    tax_amount = 0.2 * total_without_tax
    status = Invoice::RECEIVED_STATUSES.sample
    payment_date = Faker::Date.between(from: '2022-03-08', to: '2022-03-22') if status == "paid"
    declined_reasons = ["pas de tva", "pas de total HT", "adresse manquante"]
    declined_reason = declined_reasons.sample if status == "declined"
    Invoice.create!(
      sender: partner,
      recipient: le_wagon,
      issue_date: Faker::Date.between(from: '2022-03-01', to: '2022-03-03'),
      po_number: Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3),
      vat_rate: 20,
      total_wo_tax: total_without_tax,
      status: status,
      payment_deadline: Faker::Date.between(from: '2022-03-15', to: '2022-03-22'),
      payment_date: payment_date,
      archived: false,
      decline_reason: declined_reason,
      payment_method: "virement SEPA",
      total_w_tax: total_without_tax + tax_amount,
      tax_amount: tax_amount
    )
  end
end
invoicefixe = Invoice.create!(
      sender: office_depot,
      recipient: le_wagon,
      issue_date: '2022-03-01',
      po_number: 'INV00106',
      vat_rate: 20,
      total_wo_tax: 550,
      status: 'received',
      payment_deadline: Faker::Date.between(from: '2022-03-15', to: '2022-03-22'),
      payment_date: '2022-03-11',
      archived: false,
      decline_reason: "",
      payment_method: "virement SEPA",
      total_w_tax: 660,
      tax_amount: 110
    )
file2 = File.open('app/assets/images/lewagon.pdf')
invoicefixe.invoice_file.attach(io: file2, filename: 'invoice.pdf', content_type: 'application/pdf')

puts "companies and invoices created !"

puts "destroying all users..."
User.destroy_all
puts "creating new users..."

file2 = URI.open('https://ca.slack-edge.com/T02NE0241-U02T2GDMEMC-ffb6e06fd496-512')
user2 = User.create!(company: le_wagon, email: 'fabrice@lewagon.com', first_name: 'fabrice', last_name: 'Kana', password: '123456')
user2.photo.attach(io: file2, filename: 'fabrice.png', content_type: 'image/png')

file3 = URI.open('https://ca.slack-edge.com/T02NE0241-U02T1432ZNV-1f5224b774b8-512')
user3 = User.create!(company: le_wagon, email: 'martin@lewagon.com', first_name: 'martin', last_name: 'Dubois', password: '123456')
user3.photo.attach(io: file3, filename: 'martin.png', content_type: 'image/png')

file4 = URI.open('https://ca.slack-edge.com/T02NE0241-U02S4915Q8P-d896b97128d9-512')
user4 = User.create!(company: le_wagon, email: 'celine@lewagon.com', first_name: 'celine', last_name: 'condoris', password: '123456')
user4.photo.attach(io: file4, filename: 'celine.png', content_type: 'image/png')

puts "users created !"
