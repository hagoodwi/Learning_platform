class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.date :start_date
      t.date :end_date
      t.text :description
      t.string :name

      t.timestamps
    end
  end
end
