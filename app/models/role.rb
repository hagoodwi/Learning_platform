class Role < ApplicationRecord
    has_many :role_user
    has_many :user, through: :role_user
end
