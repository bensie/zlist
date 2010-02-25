ActionMailer::Base.smtp_settings = {
  :address => ENV['email_server'],
  :domain => ENV['email_domain']
}