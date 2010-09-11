class RenamePresenterToParticipant < ActiveRecord::Migration
  def self.up
    change_table :media_items do |t|
      t.rename :presenter_name, :participant_name
      t.rename :presenter_role, :participant_role
    end
  end

  def self.down
    change_table :media_items do |t|
      t.rename :participant_name, :presenter_name
      t.rename :participant_role, :presenter_role
    end
  end
end
