class UserMailer < ActionMailer::Base
  default from: "admin@spacebook.herokuapp.com"

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Spacebook!")
  end
end
