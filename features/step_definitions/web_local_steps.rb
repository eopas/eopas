
Then /^(?:|I )should see the image "([^\"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_xpath("//img[@src[contains(string(),#{text})]]")
  else
    assert page.has_xpath?("//img[@src[contains(string(),#{text})]]")
  end
end

When /^(?:|I )attach the file "([^"]*)" with full path to "([^"]*)"$/ do |path, field|
  attach_file(field, File.join(Rails.root, path))
end

When /^I go back$/ do
  visit page.driver.last_request.env['HTTP_REFERER']
end

When /^(?:|I )make a DELETE request to (.+)$/ do |page_name|
  visit_delete path_to(page_name)
end

When /^(?:|I )select "([^"]*)" as the "([^"]*)" date$/ do |date, date_label|
  select_date(date, :from => date_label)
end

