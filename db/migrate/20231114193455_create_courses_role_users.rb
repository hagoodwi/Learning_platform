class CreateCoursesRoleUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :courses_role_users do |t|
      t.references :course, null: false, foreign_key: true
      t.references :role_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
