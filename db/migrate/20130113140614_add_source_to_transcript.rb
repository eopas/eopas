class AddSourceToTranscript < ActiveRecord::Migration
  def change
    add_column :transcripts, :source, :string
  end
end
