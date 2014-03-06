# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.where('email <> "admin@admin.com"').destroy_all

unless User.where(email: 'admin@admin.com').first
  User.create!(email: 'admin@admin.com', password: 'admin', password_confirmation: 'admin', phone: '12345678910', name: 'Админ Админович')
end

[
   ['ivanov@ivanov.com', '87021231231', 'password', 'Ivan Ivanov'],
    ['petrov@petrov.com', '87079998899', 'password', 'Petr Petrov'],
    ['sidorov@sidorov.com', '87780099009', 'password', 'Sidor Sidorov'],
].each do |user|
  user = User.create!(email: user[0], phone: user[1], password: user[2], password_confirmation: user[2], name: user[3])

  [
      [1, (1..31)],
      [2, (1..28)],
      [3, (1..31)],
  ].each do |month|
    month.to_a[1].each do |day|
      Statistic.create!(
          day: Date.parse("2014-0#{month[0]}-#{day}"),
          count: (1..30).to_a.sample,
          duration: (10..3600).to_a.sample,
          user_id: user.id
      )
    end
  end
end