scalar = 40
photos_count = 0

def generate_comments(user, commentable_class)
  commentable_class.where(author_id: user.friends.pluck(:id)).shuffle[0..(rand(20))].each do |commentable|
    commentable.comments.create!(
      author_id:  user.id,
      content:    Faker::Lorem.sentence,
      created_at: Faker::Time.between(commentable.created_at, Time.now)
    )

    commentable.likes.create!(liker_id: user.id)
  end
end


if User.where(email: "jane.smith@example.com").length == 0
  # create a test user
  test_user = User.create!(
    first_name: "Jane",
    last_name:  "Smith",
    email:      "jane.smith@example.com",
    password:   "password",
    gender:     "Female",
    birthday:   Date.today - 21.years
  )

  test_user.posts.create!(content: "First!")
end


# generate users
puts "Creating users..."
users = (1..scalar).map do |i|
  User.create!(
    first_name: first_name = Faker::Name.first_name,
    last_name:  last_name  = Faker::Name.last_name,
    email:      Faker::Internet.free_email(first_name + " " + last_name),
    password:   Faker::Internet.password(8),
    gender:     ["Female", "Male", "Other"].sample,
    birthday:   Faker::Date.between(73.years.ago, 13.years.ago),
    created_at: Faker::Time.between(6.months.ago, Time.now)
  )
end

puts "Generating posts and photos..."
users.each do |user|
  # generate friends
  User.where.not(id: user.id).shuffle[0..(scalar/3)].each { |friend| user.friended_users << friend }

  # generate posts
  (rand(20)+1).times do
    user.posts.create!(
      content:    Faker::Hacker.say_something_smart,
      created_at: Faker::Time.between(user.created_at, Time.now + 7.days)
    )
  end

  # generate photos
  (rand(5)+1).times do
    STDOUT.write "\r#{photos_count += 1}..."
    photo = user.photos.build(created_at: Faker::Time.between(user.created_at, Time.now))
    photo.photo_from_url(Faker::Avatar.image)
    photo.save!
  end

  # generate profile info
  user.profile.update!(
    school:         Faker::Company.name,
    hometown:       Faker::Address.city,
    current_town:   Faker::Address.city,
    phone_number:   Faker::PhoneNumber.phone_number,
    quotes:         Faker::Lorem.sentence,
    about:          Faker::Lorem.paragraph,
    photo_id:       user.photos.shuffle.first.id,
    cover_photo_id: user.photos.shuffle.first.id
  )
end


# accept all friend requests
puts "\nAccepting friend requests..."
users.each do |user|
  user.friend_requests.each { |friend| user.friended_users << friend }
end


# generate comments and likes
puts "Generating comments..."
users.each do |user|
  # for posts
  generate_comments(user, Post)

  # for photos
  generate_comments(user, Photo)
end


# generate likes for comments
users.each do |user|
  Comment.where(author_id: user.friends.pluck(:id)).shuffle[0..(rand(20))].each do |comment|
    comment.likes.create!(liker_id: user.id)
  end
end
