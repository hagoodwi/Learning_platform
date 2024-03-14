class CreateChatsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :chats_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :chat, null: false, foreign_key: true
      # t.index %i[user_id chat_id], unique:  true 
      t.timestamps
    end
  end
end
