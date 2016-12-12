class DropMailboxerConversationOptOuts < ActiveRecord::Migration
  def up
    drop_table :mailboxer_conversation_opt_outs
  end

  def down
    create_table :mailboxer_conversation_opt_outs do |t|
      t.references :unsubscriber, :polymorphic => true
      t.references :conversation, :index => true
    end
  end
end
