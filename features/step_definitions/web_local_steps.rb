
When /^I select "(.*)" as the "(.*)" date$/ do |date, date_label|
  day, month, year = date.split(' ')

  select year,  :from => "#{date_label}_1i"
  select month, :from => "#{date_label}_2i"
  select day,   :from => "#{date_label}_3i"
end

Then /^(?:|I )should see the image "([^\"]*)"(?: within "([^\"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_xpath("//img[@src[contains(string(),#{text})]]")
    else
      assert page.has_xpath?("//img[@src[contains(string(),#{text})]]")
    end
  end
end