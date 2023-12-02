class Discipline < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    has_many :materials
end
