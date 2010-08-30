class User < ActiveRecord::Base
  acts_as_authentic

  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation

  serialize :roles, Array

  has_many :media_items, :foreign_key => :depositor_id
  has_many :transcripts, :foreign_key => :depositor_id


  validates_presence_of :first_name, :last_name


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

  def to_s
    "\nuser {\n"+
    "   id:         "+self.id.to_s+"\n"+
    "   email:      "+self.email.to_s+"\n"+
    "   first_name: "+self.first_name.to_s+"\n"+
    "   last_name:  "+self.last_name.to_s+"\n"+
    "   roles:      "+self.roles.to_s+"\n"+
    "   created:    "+self.created_at.to_s+"\n"+
    "}\n"
  end

end

