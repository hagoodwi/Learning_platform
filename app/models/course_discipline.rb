class CourseDiscipline < ApplicationRecord
  belongs_to :course
  belongs_to :discipline
  has_and_belongs_to_many :role_users

  validates :course_id, uniqueness: { scope: :discipline_id }
end
