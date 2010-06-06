class CreateAppConfigs < ActiveRecord::Migration
  def self.up
    create_table :app_configs do |t|
      t.string :name
      t.string :value
      t.timestamps
    end
    add_index :app_configs, :name, :unique => true
  end

  def self.down
    drop_table :app_configs
  end
end
