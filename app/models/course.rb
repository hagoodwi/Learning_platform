class Course < ApplicationRecord
    has_and_belongs_to_many :role_users
end
