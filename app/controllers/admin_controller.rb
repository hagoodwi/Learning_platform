class AdminController < ApplicationController
    before_action :require_admin
  
    def require_admin
        redirect_to root_path, alert: 'Доступ запрещен.' unless current_user&.has_role?('admin')
    end
  end