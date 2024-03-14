class Chat < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :users
    has_many :messages, -> { sorted }, dependent: :destroy
end
