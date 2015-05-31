# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Users

32.times do
  u = User.new

  u.first_name = Faker::Name.first_name
  u.last_name  = Faker::Name.last_name
  u.email      = Faker::Internet.free_email(u.name)
  u.password   = Faker::Internet.password(8)
  u.gender     = ["Female", "Male", "Other"].sample
  u.birthday   = Faker::Date.between(73.years.ago, 13.years.ago)
  u.created_at = Faker::Time.between(6.months.ago, Time.now)

  u.save

  # Add some photos
  (rand(10)+1).times do
    photo = u.photos.build(created_at: Faker::Time.between(u.created_at, Time.now))
    photo.photo_from_url(Faker::Avatar.image)
    photo.save
  end

  # Profile
  u.profile.update({
    school:         Faker::Company.name,
    hometown:       Faker::Address.city,
    current_town:   Faker::Address.city,
    phone_number:   Faker::PhoneNumber.phone_number,
    quotes:         Faker::Lorem.sentence,
    about:          Faker::Lorem.paragraph,
    created_at:     u.created_at,
    photo_id:       u.photos.shuffle.first.id,
    cover_photo_id: u.photos.shuffle.first.id
  })

  # give them eight friends
  User.where.not(id: u.id).shuffle[0..8].each { |friend| u.friended_users << friend }

  # Add some posts
  (rand(20)).times do
    post = u.posts.create({
      content:    Faker::Hacker.say_something_smart,
      created_at: Faker::Time.between(u.created_at, Time.now)
    })
  end
end

# bots accept all friend requests
User.where.not(id: 1) do |user|
  user.friend_requests.each { |friend| u.friended_users << friend }
end

# Comments
User.where.not(id: 1).each do |user|
  Post.where(author_id: user.friends.pluck(:id)).shuffle[0..rand(10)].each do |post|
    post.comments.create({
      author_id:  user.id,
      content:    Faker::Lorem.sentence,
      created_at: Faker::Time.between(post.created_at, Time.now)
    })
    post.likes.create(liker_id: user.id)
  end

  Photo.where(author_id: user.friends.pluck(:id)).shuffle[0..rand(10)].each do |photo|
    photo.comments.create({
      author_id:  user.id,
      content:    Faker::Lorem.sentence,
      created_at: Faker::Time.between(photo.created_at, Time.now)
    })
    photo.likes.create(liker_id: user.id)
  end
end
