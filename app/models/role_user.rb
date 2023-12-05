class RoleUser < ApplicationRecord
  belongs_to :role
  belongs_to :user
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :disciplines
end
