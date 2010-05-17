
authorization do

  role :user do
    has_permission_on :users, :to => :read
    has_permission_on :media_items, :to => :manage
  end

  role :admin do
    includes :user
  end
end

privileges do
  privilege :read,   :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy

  privilege :manage, :includes => [:create, :read, :update, :delete]
end

