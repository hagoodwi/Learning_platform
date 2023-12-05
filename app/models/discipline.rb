class Discipline < ApplicationRecord
    has_and_belongs_to_many :role_users
    has_many :materials
    
    validates :name, presence: true, uniqueness: true
end
