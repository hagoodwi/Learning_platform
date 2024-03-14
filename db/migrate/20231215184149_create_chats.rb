class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name, null: false, index: true

      t.timestamps
    end
  end
end
