class AddAttachmentVerificationFileToVendors < ActiveRecord::Migration
  def self.up
    change_table :vendors do |t|
      t.attachment :verification_file
    end
  end

  def self.down
    remove_attachment :vendors, :verification_file
  end
end
