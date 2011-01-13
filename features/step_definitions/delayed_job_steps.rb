Then /^there should be (\d+) delayed jobs?$/ do |num_jobs|
  Delayed::Job.count.should be num_jobs.to_i
end

When /^I process the delayed jobs$/ do
    Delayed::Worker.new.work_off
end

require 'kickvideo/processor'

module Kickvideo
  class Processor
    @@stub_commands = Hash.new

    def self.stub_command(cmd, result)
      cmd = Regexp.new(cmd, Regexp::MULTILINE)
      @@stub_commands[cmd] = result
    end

    protected
    alias :run_without_stub :run
    def run cmd
      key = @@stub_commands.keys.find {|m| cmd.match(m) }
      if key
        return @@stub_commands[key]
      else
        puts "YOU SHOULD MOCK #{cmd}"
        run_without_stub cmd
      end
    end
  end
end

Given /^I mock kickvideo for "([^"]+)"(?: with "([^"]*)")?$/ do |command, result|
  Kickvideo::Processor.stub_command command, result
end
