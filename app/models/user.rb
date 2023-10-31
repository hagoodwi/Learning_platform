class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :user_profile
  has_and_belongs_to_many :groups

  after_create :create_user_profile, :assign_default_group

  attr_accessor :first_name, :second_name, :last_name

  validates :first_name, presence: true

  private
    def create_user_profile
      self.create_user_profile!(first_name: self.first_name, second_name: self.second_name, last_name: self.last_name, is_block: false)
    end

    def assign_default_group
      default_group = Group.find_or_create_by(name: "Users")
      self.groups << default_group
    end
end
