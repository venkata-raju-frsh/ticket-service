class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :user_role_assignments
  has_many :user_roles, through: :user_role_assignments
  has_many :tickets
  has_one :ticket_assignment
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  before_create :set_as_regular_user

  private
  def set_as_regular_user
    regular_user_role = UserRole.find_by(name: "REGULAR")
    self.user_roles = [ regular_user_role ]
  end
end