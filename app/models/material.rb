class Material < ApplicationRecord
  has_one_attached :file
  belongs_to :discipline
  has_one :material_access, dependent: :destroy
  belongs_to :material_type
end
