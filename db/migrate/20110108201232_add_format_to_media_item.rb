class AddFormatToMediaItem < ActiveRecord::Migration
  def self.up
    change_table :media_items do |t|
      t.string :format
    end

    MediaItem.connection.schema_cache.clear!
    MediaItem.reset_column_information
    MediaItem.update_all ['format = ?', 'video']
  end

  def self.down
    change_table :media_items do |t|
      t.remove :format
    end
  end
end
