ActionMailer::Base.smtp_settings = {
  address:              'smtp.billr.eu',
  port:                 587,
  domain:               'billr.eu',
  user_name:            ENV['BILLR_EMAIL_ADDRESS'],
  password:             ENV['BILLR_EMAIL_PASSWORD'],
  authentication:       :login,
  enable_starttls_auto: true,
  # open_timeout:         5,
  # read_timeout:         5
}
