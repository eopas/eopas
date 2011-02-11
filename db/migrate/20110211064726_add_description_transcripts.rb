class AddDescriptionTranscripts < ActiveRecord::Migration
  def self.up
    change_table :transcripts do |t|
      t.text :description
    end
  end

  def self.down
    change_table :transcripts do |t|
      t.remove :description
    end
  end
end
