class User < ActiveRecord::Base
  acts_as_authentic

  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation

  serialize :roles, Array

  def full_name
    "#{first_name} #{last_name}"
  end

  def confirm!
    self.confirmed_at = Time.now.utc
    #add_role(:user)
  end

  # Authlogic won't log someone in till this is true
  def confirmed?
    !(new_record? || confirmed_at.nil?)
  end

  # Manage roles, roles stored as symbols
  def add_role(role)
    (self.roles ||= []) << role
    roles.uniq!
  end

  # Roles returns e.g. [:admin], for declarative_auth
  def role_symbols
    roles || []
  end

end

