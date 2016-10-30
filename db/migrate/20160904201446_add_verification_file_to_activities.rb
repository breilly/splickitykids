class AddVerificationFileToActivities < ActiveRecord::Migration
  def self.up
    change_table :activities do |t|
      t.attachment :verification_file
    end
  end

  def self.down
    remove_attachment :activities, :verification_file
  end
end