class CreateCourseDisciplines < ActiveRecord::Migration[7.0]
  def change
    create_table :course_disciplines do |t|
      t.references :course, null: false, foreign_key: true
      t.references :discipline, null: false, foreign_key: true

      t.timestamps
    end
  end
end
