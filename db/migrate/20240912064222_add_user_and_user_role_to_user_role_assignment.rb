class AddUserAndUserRoleToUserRoleAssignment < ActiveRecord::Migration[7.2]
  def change
    add_reference :user_role_assignments, :user_role, null: false, foreign_key: true
    add_reference :user_role_assignments, :user, null: false, foreign_key: true
  end
end
