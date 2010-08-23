require 'transcription/transcription'

When /^I validate the transcription "([^"]*)" as an "([^"]*)" format$/ do |file, format|
  tran = File.read("features/test_data/#{file}")
  @transcription = Transcription.new(:data => tran, :format => format.to_sym)

  @transcription.validate
end

Then /^the transcription should be valid$/ do
  if !@transcription.valid?
    @transcription.errors().each do |error|
      puts error.message
    end
  end
  @transcription.should be_valid
end

Then /^the transcription should not be valid$/ do
  @transcription.should_not be_valid
end


When /^I transcode the transcription "([^"]*)" as an "([^"]*)" format in directory "([^"]*)"$/ do |file, format, directory|
  tran = File.read("#{directory}#{file}")
  @transcription = Transcription.new(:data => tran, :format => format.to_sym)

  @transcription.transcode_to(:file => "#{directory}e_#{file}")
end

Then /^a transcription "([^"]*)" should exist in directory "([^"]*)"$/ do |filename, directory|
  File.exists?(directory+filename).should be_true
end