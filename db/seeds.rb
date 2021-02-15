# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.find_or_create_by(id: 1) do |admin|
  admin.email = ENV['ADMIN_EMAIL']
  admin.password = ENV['ADMIN_PASSWORD']
end

User.create!(
  [
    {
      nickname: 'ゲスト',
      biography: 'ゲストです。よろしくおねがいします。',
      email: 'test1234user5678@example.com',
      password: '123456789',
    },
    {
      nickname: 'アリス',
      biography: 'アリスです。よろしくおねがいします。',
      email: 'test1234alice5678@example.com',
      password: 'aaaaaa',
    },
    {
      nickname: 'ボブ',
      biography: 'ボブです。よろしくおねがいします。',
      email: 'test1234bob5678@example.com',
      password: 'bbbbbb',
    },
  ]
)
