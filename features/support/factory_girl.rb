require 'factory_girl'

FactoryGirl.define do

  factory :user do
    sequence(:email) {|n| "johnf#{n}@inodes.org"}
    password 'really_secret'
    password_confirmation { |a| a.password }
    first_name 'John'
    last_name 'Ferlito'
    confirmed_at Time.now
    roles [:user]
  end

  factory :admin_user, :parent => :user do
    roles [:admin]
  end

  # Having unconfirmed be special means we can just use user in most places
  factory :unconfirmed_user, :parent => :user do
    confirmed_at nil
  end

  factory :media_item do
    title 'test video'
    description 'Video created for tesing purposes'
    recorded_on Time.now
    copyright 'Robot Parade 2010'
    license 'PD'
    private true
    association :depositor, :factory => :user
    format 'video'
    original { File.open(File.join(Rails.root, 'features', 'test_data', 'test.m4v')) }
  end


  factory :transcript do
    sequence(:title) {|n| "Title#{n}"}
    date Time.now
    country_code 'AU'
    language_code 'en'
    copyright 'Robot Parade 2010'
    license 'PD'
    private true
    association :depositor, :factory => :user
    source { File.open(File.join(Rails.root, 'features', 'test_data', 'eopas3.xml')) }
    transcript_format 'EOPAS'
  end

  factory :transcript_phrase do
  end

  factory :transcript_word do
  end

  factory :transcript_morpheme do
  end

end
