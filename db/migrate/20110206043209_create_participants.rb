class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.string :name
      t.string :role
      t.belongs_to :transcript

      t.timestamps
    end
  end

  def self.down
    drop_table :participants
  end
end
