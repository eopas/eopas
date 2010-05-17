Then(/debugger/) do
  u = User.find(1)
  puts u.roles
end
