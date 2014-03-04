# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.where('username <> "admin"').destroy_all

unless User.where(username: 'admin').first
  User.create!(username: 'admin', password: 'admin', password_confirmation: 'admin', phone: '12345678910')
end

[
    %w( ivanov  87021231231 password),
    %w( petrov  87079998899 password),
    %w( sidorov 87780099009 password)
].each do |user|
  user = User.create!(username: user[0], phone: user[1], password: user[2], password_confirmation: user[2])

  [
      [1, (1..31)],
      [2, (1..28)],
      [3, (1..31)],
  ].each do |month|
    month.to_a[1].each do |day|
      Statistic.create!(
          day: Date.parse("2014-0#{month[0]}-#{day}"),
          count: (0..20).to_a.sample,
          duration: (10..3600).to_a.sample,
          user_id: user.id
      )
    end
  end
end