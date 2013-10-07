class DeprecatePaperclip < ActiveRecord::Migration
  def change
    change_table :media_items do |t|
      t.rename :original_processing, :media_processing
      t.rename :original_file_name, :media
      t.remove :original_content_type
      t.remove :original_file_size
      t.remove :original_updated_at
    end

    change_table :transcripts do |t|
      t.rename :original_file_name, :source
      t.remove :original_content_type
      t.remove :original_file_size
      t.remove :original_updated_at
    end
  end
end
