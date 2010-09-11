#! /usr/bin/env ruby

# call this as: 
# rails runner bin/validate.rb features/test_data/toolbox2.xml Toolbox

require 'transcription'

t = Transcription.new(:data => File.read(ARGV[0]), :format => ARGV[1])
t.validate
if t.valid?
  puts "valid file"
else
  puts t.errors
end