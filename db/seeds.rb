Rating.destroy_all
Comment.destroy_all
Location.destroy_all
User.destroy_all

User.create(
  username: "test1",
  email: "test1@hg.com",
  password: "password",
  admin: true
)

User.create(
  username: "test2",
  email: "test2@hg.com",
  password: "password",
  admin: true
)

categories = ["art","photography","nature","other"]

categories.each do |c|
  Category.create(name: c)
end