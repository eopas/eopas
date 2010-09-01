class TranscriptItem < ActiveRecord::Migration
  def self.up
    create_table :transcripts do |t|
      # resource relationship
      t.belongs_to :media_item, :null => false
      t.belongs_to :depositor, :null => false

      # dublin core meta data, see http://dublincore.org/documents/2006/12/18/dcmi-terms/
      t.string :creator
      t.string :language_code
      t.string :date

      # media resource info
      t.string   :original_file_name
      t.string   :original_content_type
      t.string   :original_file_size
      t.datetime :original_updated_at
      t.string   :transcription_format

      # creation and update timestamps
      t.timestamps
    end

    create_table :transcript_tiers do |t|
      # transcript relationship
      t.belongs_to :transcript, :null => false
      # hierarchical tiers
      t.belongs_to :parent, :null => true

      # can belong to multiple text tracks for the same input file
      t.string :tier_id
      t.string :language_code
      t.string :linguistic_type
    end
    add_index :transcript_tiers, [:transcript_id, :tier_id], :unique => true

    create_table :transcript_phrases do |t|
      # transcript relationship
      t.belongs_to :transcript_tier, :null => false

      # metadata
      t.string :phrase_id
      t.float  :start_time, :null => false
      t.float  :end_time, :null => false
      t.string :text
      t.string :participant

      # hierarchical tier: related phrase
      t.string :ref_phrase
    end
  end

  def self.down
    drop_table :transcript_phrases
    drop_table :transcript_tiers
    drop_table :transcripts
  end
end
