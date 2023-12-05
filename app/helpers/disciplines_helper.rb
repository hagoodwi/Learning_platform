module DisciplinesHelper
    def get_role_user_by_role(role)
        RoleUser.joins(:role).find_by(users: { id: current_user.id }, roles: { name: role })
    end
end
