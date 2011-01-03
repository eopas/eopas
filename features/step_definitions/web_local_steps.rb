
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
