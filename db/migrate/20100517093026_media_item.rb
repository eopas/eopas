class MediaItem < ActiveRecord::Migration
  def self.up
    create_table :media_items do |t|
      t.string     :title,     :null => false
      t.belongs_to :depositor, :null => false

      t.string :original_file_name
      t.string :original_content_type
      t.string :original_file_size
      t.string :original_updated_at

      t.timestamps
    end

  end

  def self.down
    drop_table :media_items
  end
end
