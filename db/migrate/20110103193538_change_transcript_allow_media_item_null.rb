class ChangeTranscriptAllowMediaItemNull < ActiveRecord::Migration
  def self.up
    change_column :transcripts, :media_item_id, :integer, :null => true
  end

  def self.down
    change_column :transcripts, :media_item_id, :integer, :null => false
  end
end
