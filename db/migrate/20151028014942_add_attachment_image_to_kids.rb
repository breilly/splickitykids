class AddAttachmentImageToKids < ActiveRecord::Migration
  def self.up
    change_table :kids do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :kids, :image
  end
end
