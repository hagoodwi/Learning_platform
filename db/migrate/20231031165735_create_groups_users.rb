class CreateGroupsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :groups_users do |t|
      t.belongs_to :user
      t.belongs_to :group
      t.timestamps
    end
  end
end
