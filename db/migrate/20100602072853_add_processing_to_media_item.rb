class AddProcessingToMediaItem < ActiveRecord::Migration
  def self.up
    add_column :media_items, :original_processing, :boolean
  end

  def self.down
    remove_column :media_items, :original_processing
  end
end
