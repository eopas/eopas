Then /^there should be (\d+) delayed jobs?$/ do |num_jobs|
  Delayed::Job.count.should be num_jobs.to_i
end

When /^I process the delayed jobs$/ do
  Delayed::Worker.new.work_off
end
