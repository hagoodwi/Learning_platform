class ModeratorController < ApplicationController
    before_action :access_check
  
    def access_check
        # Можно сразу достать эту запись roleUser для дальнейщего использования
        @is_admin = current_user&.has_role?('admin')
        redirect_to root_path, alert: 'Доступ запрещен.' unless @is_admin || current_user&.has_role?('moderator')
    end
end
