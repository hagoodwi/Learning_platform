class Course < ApplicationRecord
    has_and_belongs_to_many :role_users
    has_many :course_disciplines
    has_many :disciplines, through: :course_disciplines
end
