class Moderator::MaterialsController < ModeratorController
    before_action :check_access_to_discipline, 
            only: [:show, :edit, :update, :destroy]

    def new
        @material = @discipline.materials.build
        # @discipline = Discipline.find(params[:discipline_id])
    end

    def show
        @material = Material.find(params[:id])
        @material_access = MaterialAccess.find_or_initialize_by(material_id: @material.id)
    end

    private
        def check_access_to_discipline
            @discipline = Discipline.find(params[:discipline_id])
            redirect_to root_path, alert: 'Доступ запрещен' unless @discipline.role_users.exists?(user_id: current_user.id, role_id: Role.find_by(name: 'moderator')&.id) || @is_admin
        end

        def course_params
            params.require(:course).permit(:name, :start_date, :end_date, :description, :teacher_role_users, :student_role_users, :discipline_ids)
        end
end
