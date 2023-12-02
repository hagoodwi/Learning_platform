class Material < ApplicationRecord
  has_one_attached :file
  belongs_to :discipline
end
