# ゲストユーザー作成
User.create!(
  name: "テスト太郎",
  user_name: "guest-user",
  email: "guest@example.com",
  web_site: Faker::Internet.url,
  self_intro: Faker::Lorem.sentence,
  phone_number: Faker::PhoneNumber.phone_number,
  sex: 1,
  password: 'password',
  password_confirmation: 'password'
)

image_num_array=[*1..10].shuffle!

10.times do |n|
  email="example-#{n}@example.com"
  name = Faker::Name.name
  user_name = Faker::Internet.user_name
  sex = [1, 2, 3].sample(1)
  password="password"
  image_num=image_num_array.shift
  User.create!(
    email: email,
    name: name,
    user_name: user_name,
    web_site: Faker::Internet.url,
    self_intro: Faker::Lorem.sentence,
    phone_number: Faker::PhoneNumber.phone_number,
    sex: sex,
    password: password,
    password_confirmation: password,
  )
end

# # ポスト
# post_image_num_array=[*1..62].shuffle!

# User.all.each do |user|
#   5.times do |i|
#     image_num = post_image_num_array.shift
#     user.igposts.create(
#       image: File.open("#{Rails.root}/db/image_seeds/#{image_num}.jpg")
#     )
#   end
# end

# リレーション
users = User.all
users.each do |user|
  followings = users.where.not(id: user.id).sample(6)
  followings.each { |followed| user.follow(followed) }
end