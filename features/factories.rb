
# Paperclip attachments in factories, made easy based on technicalpickles
# TODO: JF clean up
Factory.class_eval do
  def attach(name, path, content_type = nil)
    if content_type
      add_attribute name, Rack::Test::UploadedFile.new("#{Rails.root}/#{path}", content_type)
    else
      add_attribute name, Rack::Test::UploadedFile.new("#{Rails.root}/#{path}")
    end
  end
end


Factory.define :user do |u|
  u.sequence(:email) {|n| "johnf#{n}@inodes.org"}
  u.password 'really_secret'
  u.password_confirmation { |a| a.password }
  u.first_name 'John'
  u.last_name 'Ferlito'
  u.confirmed_at Time.now
  u.roles [:user]
end

# Having unconfirmed be special means we can just use user in most places
Factory.define :unconfirmed_user, :parent => :user do |u|
  u.confirmed_at nil
end

Factory.define :media_item do |m|
  m.title 'test video'
  m.private true
  m.format 'video'
  m.recorded_at Time.now
  m.country_code 'au'
  m.language_code 'en'
  m.license 'PD'
  m.attach( "original", "features/test_data/test.m4v", "video/mp4" )
  m.association :depositor, :factory => :user
end


Factory.define :transcript do |t|
  t.sequence(:title) {|n| "Title#{n}"}
  t.attach "original", "features/test_data/elan1.xml", "text/xml"
  t.transcript_format 'ELAN'
  t.association :depositor, :factory => :user
end

#Factory.define :transcript_tier do |t|
#end
#
#Factory.define :transcript_phrase do |t|
#end

