Given /^I am logged in as #{capture_model}$/ do |user|
  user = model!(user)

  Given 'I go to the homepage'
  And 'I follow "Login"'
  And "I fill in \"Email\" with \"#{user.email}\""
  And "I fill in \"Password\" with \"#{Factory.attributes_for(:user)[:password]}\""
  And 'I press "Login"'
end 

Given /^I am logged out$/ do
  When 'I go to the logout page'
end

