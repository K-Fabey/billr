# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'
require 'faker'

User.destroy_all

file2 = URI.open('https://ca.slack-edge.com/T02NE0241-U02T2GDMEMC-ffb6e06fd496-512')
user2 = User.create!(email: 'fabrice@gmail.com', first_name: 'fabrice', last_name: 'Kana', password: '123456')
user2.photo.attach(io: file2, filename: 'fabrice.png', content_type: 'image/png')

file3 = URI.open('https://ca.slack-edge.com/T02NE0241-U02T1432ZNV-1f5224b774b8-512')
user3 = User.create!(email: 'martin@gmail.com', first_name: 'martin', last_name: 'Dubois', password: '123456')
user3.photo.attach(io: file3, filename: 'martin.png', content_type: 'image/png')

file4 = URI.open('https://ca.slack-edge.com/T02NE0241-U02S4915Q8P-d896b97128d9-512')
user4 = User.create!(email: 'celine@gmail.com', first_name: 'celine', last_name: 'condoris', password: '123456')
user4.photo.attach(io: file4, filename: 'celine.png', content_type: 'image/png')

Company.destroy_all
# Company.create!(name:'EDF', siren:'4563256', siret: user: User.all.sample....

10.times do
    company = Company.new(
      name: Faker::Company.name,
      siren: Faker::Number.decimal(l_digits: 9),
      siret: Faker::Number.decimal(l_digits: 14),
      address: Faker::Address.name,
      city: Faker::Address.city,
      country: Faker::Address.country,
      phone_number: Faker::Number.decimal(l_digits: 10),
      vat_number: "FR#{Faker::Number.decimal(l_digits: 11)}",
      email: Faker::Internet.email,
      bank_account: "FR#{Faker::Number.decimal(l_digits: 25)}",
      legal_status: Faker::Company.type,
      capital: "#{Faker::Number.decimal(l_digits: 6)} €",
      company_id: User.all.sample
    )
    company.save!
end
