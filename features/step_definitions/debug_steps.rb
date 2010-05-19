Then(/debugger/) do
  u = User.find(1)
  puts u.roles
end

Then(/print me the page/) do
  puts page.body
end


