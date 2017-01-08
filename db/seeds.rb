# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


10.times do
  u = User.create!(name: FFaker::Name.name, email: rand(1000).to_s + FFaker::Internet.email, password: "password", password_confirmation:"password", default_type:"nanny")
  pp u if Rails.env.development?
  nanny = u.nanny


  start = Time.now
  3.times do
    start = start + 1.days + rand(10).days
    endt = start + 1.hour + rand(8).hours
    puts "*-*"
      pp start
      pp endt
    puts "*-*"
    Slot.create!(start_time: start, end_time: endt, nanny: nanny)
    start = endt
  end
end
