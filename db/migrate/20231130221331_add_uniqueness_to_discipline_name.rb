class AddUniquenessToDisciplineName < ActiveRecord::Migration[7.0]
  def change
    add_index :disciplines, :name, unique: true
  end
end
