class AddCountry < ActiveRecord::Migration
  def self.up
    change_table :media_items do |t|
      t.string   :country_code
    end
    change_table :transcripts do |t|
      t.string   :country_code
    end
    change_column :transcripts, :date, :datetime
  end

  def self.down
    change_table :media_items do |t|
      t.remove :country_code
    end
    change_table :transcripts do |t|
      t.remove :country_code
    end
    change_column :transcripts, :date, :string
  end
end
