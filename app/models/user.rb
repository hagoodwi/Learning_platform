class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :user_profile
  has_and_belongs_to_many :groups
  has_many :role_users
  has_many :roles, through: :role_users

  after_create :create_user_profile, :assign_default_group, :assign_user_role

  attr_accessor :first_name, :second_name, :last_name
  # accepts_nested_attributes_for :user_profile

  validates :first_name, presence: true

  def full_name
    "#{self.user_profile.last_name} #{self.user_profile.first_name} #{self.user_profile.second_name}"
  end

  def has_role?(role_name)
    self.roles.exists?(name: role_name)
  end

  def get_role_user(role_name)
    RoleUser.joins(:role).find_by(user_id: self.id, roles: { name: role_name })
  end

  private
    def assign_user_role
      user_role = Role.find_or_create_by(name: "admin")
      self.roles << user_role
    end

    def create_user_profile
      self.create_user_profile!(first_name: self.first_name, second_name: self.second_name, last_name: self.last_name, is_block: false)
    end

    def assign_default_group
      default_group = Group.find_or_create_by(name: "Users")
      self.groups << default_group
    end
end
