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

#  # Manage roles, roles stored as strings
#  def add_role(role)
#    role = role.to_s
#    (self.roles ||= []) << role
#    roles.uniq!
#  end

#  # Roles returns e.g. [:admin], for declarative_auth
#  def role_symbols  
#    @role_symbols ||= (roles || []).map {|r| r.to_sym}
#  end

end

