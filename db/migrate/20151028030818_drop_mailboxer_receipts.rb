class DropMailboxerReceipts < ActiveRecord::Migration
  def up
    drop_table :mailboxer_receipts
  end

  def down
    create_table :mailboxer_receipts do |t|
      t.references :receiver, :polymorphic => true, :index => true
      t.column :notification_id, :integer, :null => false
      t.column :is_read, :boolean, :default => false
      t.column :trashed, :boolean, :default => false
      t.column :deleted, :boolean, :default => false
      t.column :mailbox_type, :string, :limit => 25
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime, :null => false
    end
    add_index "mailboxer_receipts","notification_id"
  end
end
