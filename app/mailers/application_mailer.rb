class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("EMAIL_USERNAME")
  layout "mailer"
end
