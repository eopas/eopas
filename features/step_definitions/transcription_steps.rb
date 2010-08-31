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

Then /^a transcription "([^"]*)" should not exist in directory "([^"]*)"$/ do |filename, directory|
  File.exists?(directory+filename).should be_false
end


When /^I import the transcription "([^"]*)" in directory "([^"]*)" for #{capture_model}$/ do |file, directory, media_item|
  media_item = model!(media_item)
  tran = File.read("#{directory}#{file}")
  @transcription = Transcription.new(:data => tran, :format => :eopas, :media_item => media_item)
  @transcription.save_eopas(:file => "#{directory}#{file}", :media_item => media_item, :depositor => @user)
end


Then /^a transcript should exist with depositor: user "([^"]*)" for #{capture_model}$/ do |depositor, media_item|
  media_item = model!(media_item)
  @transcript = Transcript.find(:all, :conditions => {:media_item_id => media_item.id, :depositor_id => @user.id})
  @transcript.size.should >= 1
end


Then /^this transcript has at least (\d+) transcript tier with at least (\d+) transcript phrase$/ do |num_tiers, num_phrases|
  @transcript[0].transcript_tiers.size.should >= num_tiers.to_i
  @transcript[0].transcript_tiers[0].transcript_phrases.size.should >= num_phrases.to_i
end
