class CreateCourseDisciplinesRoleUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :course_disciplines_role_users do |t|
      t.references :role_user, null: false, foreign_key: true
      t.references :course_discipline, null: false, foreign_key: true

      t.timestamps
    end
  end
end
