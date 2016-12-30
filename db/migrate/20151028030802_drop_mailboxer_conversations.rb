class DropMailboxerConversations < ActiveRecord::Migration
  def up
    drop_table :mailboxer_conversations
  end

  def down
    create_table :mailboxer_conversations do |t|
      t.column :subject, :string, :default => ""
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime, :null => false

      t.timestamps        
    end
  end
end
