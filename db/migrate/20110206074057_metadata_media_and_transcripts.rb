class MetadataMediaAndTranscripts < ActiveRecord::Migration
  def self.up
    change_table :media_items do |t|
      t.text     :description
      t.remove   :item_id
      t.remove   :annotator_name
      t.remove   :annotator_role
      t.remove   :participant_name
      t.remove   :participant_role
      t.remove   :language_code
    end
    rename_column :media_items, :recorded_at, :recorded_on

    change_table :transcripts do |t|
      t.string   :copyright
      t.string   :license
      t.remove   :creator
    end
  end

  def self.down
    change_table :media_items do |t|
      t.remove   :description
      t.string   :item_id
      t.string   :annotator_name
      t.string   :annotator_role
      t.string   :participant_name
      t.string   :participant_role
      t.string   :language_code
    end
    rename_column :media_items, :recorded_on, :recorded_at

    change_table :transcripts do |t|
      t.remove   :copyright
      t.remove   :license
      t.string   :creator
    end
  end
end
