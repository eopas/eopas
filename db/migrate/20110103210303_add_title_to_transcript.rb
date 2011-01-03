class AddTitleToTranscript < ActiveRecord::Migration
  def self.up
    change_table :transcripts do |t|
      t.string :title
    end
  end

  def self.down
    change_table :transcripts do |t|
      t.remove :title
    end
  end
end
