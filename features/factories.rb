
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
  m.description 'Video created for tesing purposes'
  m.recorded_on Time.now
  m.copyright 'Robot Parade 2010'
  m.license 'PD'
  m.private true
  m.association :depositor, :factory => :user
  m.format 'video'
  m.attach( "original", "features/test_data/test.m4v", "video/mp4" )
end


Factory.define :transcript do |t|
  t.sequence(:title) {|n| "Title#{n}"}
  t.date Time.now
  t.country_code 'au'
  t.language_code 'en'
  t.copyright 'Robot Parade 2010'
  t.license 'PD'
  t.private true
  t.association :depositor, :factory => :user
  t.attach "original", "features/test_data/eopas3.xml", "text/xml"
  t.transcript_format 'EOPAS'
end

Factory.define :transcript_phrase do |t|
end

Factory.define :transcript_word do |t|
end

Factory.define :transcript_morpheme do |t|
end
