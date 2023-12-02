class CreateMaterialAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :material_accesses do |t|
      t.references :material, null: false, foreign_key: true
      t.boolean :always_open
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
