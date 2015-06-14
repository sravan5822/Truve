class WelcomeMailer < ActionMailer::Base
  default from: '"Truve" <shopping@apiscience.com>'
  helper :application

  def send_welcome_message(email)
    mail to: email, subject: "Welcome to Truve"
  end
end
