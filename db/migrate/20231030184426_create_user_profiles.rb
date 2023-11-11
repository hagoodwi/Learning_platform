class CreateUserProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_profiles do |t|
      t.string :first_name
      t.string :second_name
      t.string :last_name
      t.boolean :is_block
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
