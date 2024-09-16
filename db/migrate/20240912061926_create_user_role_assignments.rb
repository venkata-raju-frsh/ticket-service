class CreateUserRoleAssignments < ActiveRecord::Migration[7.2]
  def change
    create_table :user_role_assignments do |t|
      t.timestamps
    end
  end
end
