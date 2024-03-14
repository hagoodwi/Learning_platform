class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :trackable

  # Содержится информация о пользовательских данных
  has_one :user_profile

  has_and_belongs_to_many :groups
  
  # Связь с ролями через промежуточную таблицу
  has_many :role_users
  has_many :roles, through: :role_users
  

  has_and_belongs_to_many :chats
  has_many :messages, dependent: :destroy

  # 
  after_create :create_user_profile, :assign_default_group, :assign_user_role

  attr_accessor :first_name, :second_name, :last_name

  # TODO: Нужно написать валидацию на все поля
  validates :first_name, presence: true

  # Красивый вывод ФИО
  def full_name
    "#{self.user_profile.last_name} #{self.user_profile.first_name} #{self.user_profile.second_name}"
  end

  # Сокращенный вывод ФИО
  def short_name
    "#{self.user_profile.last_name} #{self.user_profile.first_name[0]}. #{self.user_profile.second_name[0]}."
  end

  def has_role?(role_name)
    self.roles.exists?(name: role_name)
  end

  # Получение записи из связующей таблицы role_users
  def get_role_user(role_name)
    RoleUser.joins(:role).find_by(user_id: self.id, roles: { name: role_name })
  end

  # Поиск записи по комбинации ФИО
  def self.full_text_search(query)
    return all unless query.present?

    words = query.split(/\s+/)
    query_parts = words.map.with_index do |word, index|
      "(user_profiles.first_name ILIKE :word#{index} OR user_profiles.last_name ILIKE :word#{index} OR user_profiles.second_name ILIKE :word#{index})"
    end

    params = words.map.with_index.to_h { |word, index| ["word#{index}".to_sym, "%#{word}%"] }
    joins(:user_profile)
      .where(query_parts.join(' AND '), params)
  end

  private
    # Все подефолту получают изначально роль студента 
    def assign_user_role
      user_role = Role.find_or_create_by(name: "студент")
      self.roles << user_role
    end

    # Создаём запись с пользовательской информацией
    def create_user_profile
      self.create_user_profile!(first_name: self.first_name, second_name: self.second_name, last_name: self.last_name, is_block: false)
    end

    # Все подефолту попадают в группу пользователи
    def assign_default_group
      default_group = Group.find_or_create_by(name: "Пользователи")
      self.groups << default_group
    end
end
