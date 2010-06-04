
When /^I select "(.*)" as the "(.*)" date$/ do |date, date_label|
  day, month, year = date.split(' ')

  select year,  :from => "#{date_label}_1i"
  select month, :from => "#{date_label}_2i"
  select day,   :from => "#{date_label}_3i"
end