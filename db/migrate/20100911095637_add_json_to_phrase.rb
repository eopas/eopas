class AddJsonToPhrase < ActiveRecord::Migration
  def self.up
    change_table :transcript_phrases do |t|
      t.string :words
    end
  end

  def self.down
    change_table :transcript_phrases do |t|
      t.remove :words
    end
  end
end