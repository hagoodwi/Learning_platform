class AddDisciplineReferenceToMaterials < ActiveRecord::Migration[7.0]
  def change
    add_reference :materials, :discipline, null: false, foreign_key: true
  end
end
