class AddGraidToTranscriptPhrases < ActiveRecord::Migration
  def change
    add_column :transcript_phrases, :graid, :string
  end
end
