ActionMailer::Base.smtp_settings = { 
  :address              => "smtp.126.com", 
  :port                 => 25, 
  :domain               => "126.com", 
  :user_name            => "zhangm1995", 
  :password             => "zhangmi1995", 
  :authentication       => "plain", 
  :enable_starttls_auto => true 
} 