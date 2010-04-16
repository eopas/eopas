class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email,               :null => false
      t.string :crypted_password,    :null => false
      t.string :password_salt,       :null => false
      t.string :persistence_token,   :null => false
      t.string :single_access_token, :null => false
      t.string :perishable_token,    :null => false

      # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
      t.integer  :login_count,        :null => false, :default => 0
      t.integer  :failed_login_count, :null => false, :default => 0
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string   :current_login_ip
      t.string   :last_login_ip

      t.string   :first_name,          :null => false
      t.string   :last_name,           :null => false
      t.string   :roles
      t.datetime :confirmed_at

      t.timestamps
    end
    add_index :users, :email
    add_index :users, :perishable_token
  end

  def self.down
    drop_table :users
  end

end
