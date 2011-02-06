class ReorgModels < ActiveRecord::Migration
  def self.up
    change_column :transcripts, :private, :boolean, :default => false, :null => false

    drop_table :transcript_phrases
    create_table :transcript_phrases, :force => true do |t|
      t.integer :transcript_id, :null => false
      t.string  :phrase_id
      t.float   :start_time,         :null => false
      t.float   :end_time,           :null => false
      t.string  :original, :limit => 4096
      t.string  :translation, :limit => 4096
    end
    add_index :transcript_phrases, ["transcript_id", "phrase_id"], :name => "index_transcript_phrases_on_transcript_id_and_phrase_id", :unique => true

    drop_table :transcript_tiers

    create_table :transcript_words, :force => true do |t|
      t.integer :transcript_phrase_id, :null => false
      t.integer :position, :null => false
      t.string  :word, :null => false
    end
    add_index :transcript_words, ["transcript_phrase_id", "position"], :name => "index_transcript_words_on_transcript_phrase_id_and_position", :unique => true

    create_table :transcript_morphemes, :force => true do |t|
      t.integer :transcript_word_id, :null => false
      t.integer :position, :null => false
      t.string  :morpheme, :null => false
      t.string  :gloss, :null => false
    end
    add_index :transcript_morphemes, ["transcript_word_id", "position"], :name => "index_transcript_morphemes_on_transcript_word_id_and_position", :unique => true
  end

  def self.down
    change_column :transcripts, :private, :boolean, :default => true, :null => false

    drop_table :transcript_phrases
    create_table :transcript_phrases, :force => true do |t|
      t.integer :transcript_tier_id, :null => false
      t.string  :phrase_id
      t.float   :start_time,         :null => false
      t.float   :end_time,           :null => false
      t.string  :text
      t.string  :participant
      t.string  :ref_phrase
      t.string  :words
    end

    create_table :transcript_tiers, :force => true do |t|
      t.integer :transcript_id,   :null => false
      t.integer :parent_id
      t.string  :tier_id
      t.string  :language_code
      t.string  :linguistic_type
    end
    add_index :transcript_tiers, ["transcript_id", "tier_id"], :name => "index_transcript_tiers_on_transcript_id_and_tier_id", :unique => true

    drop_table :transcript_words
    drop_table :transcript_morphemes
  end
end
