class AddMediaToMediaItem < ActiveRecord::Migration
  def change
    add_column :media_items, :media, :string
  end
end
