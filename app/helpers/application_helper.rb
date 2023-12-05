module ApplicationHelper
    def active(path)
        current_page?(path) ? 'active' : ''
    end

    def path_start_with_active(prefix)
        request.fullpath.start_with?(prefix) ? 'active' : ''
    end

    def nav_active(prefix)
        request.fullpath.start_with?(prefix) ? 'secondary' : 'white'
    end

    # def get_role_user_by_role(role)
    #     RoleUser.joins(:role).find_by(users: { id: current_user.id }, roles: { name: role })
    # end

    # def path_start_with(prefix)
    #     request.fullpath.start_with?(prefix)
    # end

end
