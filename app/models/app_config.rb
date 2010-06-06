class AppConfig < ActiveRecord::Base

  validates_presence_of :name, :value
  validates_inclusion_of :name, :in => ['setup_completed']

  serialize :value, Hash

  # We dynamically support grabbing the config value
  def self.method_missing(method_id, *args, &block)
    begin
      super
    rescue
      if method_id =~ /=$/
        name = method_id.to_s.gsub(/=$/, '')
        app_config = new(:name => name, :value => {:value => args.first})
        app_config.save!
      else
        name = method_id.to_s.gsub(/\?$/, '')
        app_config = find_by_name(name)
        value = app_config ? app_config.value[:value] : nil

        value
      end
    end
  end

end
