Given /^I am logged in as #{capture_model}$/ do |user|
  @user = model!(user)

  step %Q{I go to the homepage}
  step %Q{I follow "Login"}
  step %Q{I fill in "Email" with "#{@user.email}"}
  step %Q{I fill in "Password" with "#{FactoryGirl.attributes_for(:user)[:password]}"}
  step %Q{I press "Login"}
end

Given /^I am logged out$/ do
  step %Q{I go to the logout page}
end

