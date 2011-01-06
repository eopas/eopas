class AddPrivateToTranscripts < ActiveRecord::Migration
  def self.up
    change_table :transcripts do |t|
      t.boolean :private, :null => false, :default => true
    end
  end

  def self.down
    change_table :transcripts do |t|
      t.remove :private
    end
  end
end
