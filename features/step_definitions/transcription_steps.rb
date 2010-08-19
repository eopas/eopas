require 'transcription/transcription'

When /^I validate the transcription "([^"]*)" as an "([^"]*)" format$/ do |file, format|
  tran = File.read("features/test_data/#{file}")
  @transcription = Transcription.new(:data => tran, :format => format.to_sym)

  @transcription.validate
end

Then /^the transcription should be valid$/ do
  @transcription.should be_valid
end

Then /^the transcription should not be valid$/ do
  @transcription.should_not be_valid
end
