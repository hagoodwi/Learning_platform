class Discipline < ApplicationRecord
    has_and_belongs_to_many :role_users
    has_many :materials
    has_many :course_disciplines
    has_many :courses, through: :course_disciplines
    
    validates :name, presence: true, uniqueness: true
end
