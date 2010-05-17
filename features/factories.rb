Factory.define :user do |u|
  u.email 'johnf@inodes.org'
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

