class UserMailer < ActionMailer::Base
  default :from => 'support@eopas.com'

  def registration_confirmation(user)
    @user = user
    mail :to => "#{user.full_name} <#{user.email}>", :subject => "Confirm EOPAS registration"
  end

  def forgotten_password(user)
    @user = user
    mail :to => "#{user.full_name} <#{user.email}>", :subject => "EOPAS Password Reset"
  end
end
