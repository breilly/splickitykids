class DropMailboxerConversationOptOuts < ActiveRecord::Migration
  def up
    drop_table :mailboxer_conversation_opt_outs
  end

  def down
    create_table :mailboxer_conversation_opt_outs do |t|
      t.references :unsubscriber, :polymorphic => true
      t.references :conversation
    end
    add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", :name => "mb_opt_outs_on_conversations_id", :column => "conversation_id"
  end
end
