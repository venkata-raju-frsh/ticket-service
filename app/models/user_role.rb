class UserRole < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 255 }

  has_many :user_role_assignments
  has_many :users, through: :user_role_assignments
end
