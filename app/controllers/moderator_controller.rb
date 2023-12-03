class ModeratorController < ApplicationController
    before_action :access_check
  
    def access_check
        redirect_to root_path, alert: 'Доступ запрещен.' unless current_user&.has_role?('admin') || current_user&.has_role?('moderator')
    end
end
