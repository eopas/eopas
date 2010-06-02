Then /^there should be (\d+) delayed jobs?$/ do |num_jobs|
  Delayed::Job.count.should be num_jobs.to_i
end

When /^I process the delayed jobs$/ do
    Delayed::Worker.new.work_off
end

Given /^I mock paperclip for "([^"]+)"$/ do |cmd|
  #Kernel.stub!(:`).with(cmd).and_return("")
  Paperclip.stub(:run).with(cmd).and_return("")
end
