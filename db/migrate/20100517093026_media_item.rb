class MediaItem < ActiveRecord::Migration
  def self.up
    create_table :media_items do |t|
      t.string     :title,     :null => false
      t.belongs_to :depositor, :null => false

      # media resource info
      t.string   :original_file_name
      t.string   :original_content_type
      t.string   :original_file_size
      t.datetime :original_updated_at

      # meta data
      t.string   :item_id
      t.datetime :recorded_at
      t.string   :annotator_name
      t.string   :annotator_role
      t.string   :presenter_name
      t.string   :presenter_role
      t.string   :language_code
      t.string   :copyright
      t.string   :license

      # restrictions
      t.boolean :private, :default => false

      # creation and update timestamps
      t.timestamps
    end
    add_index :media_items, :item_id, :unique => true

  end

  def self.down
    drop_table :media_items
  end
end
