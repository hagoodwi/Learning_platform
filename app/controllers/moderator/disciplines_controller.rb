class Moderator::DisciplinesController < ModeratorController
    before_action :check_access_to_discipline, only: [:show, :edit, :update, :destroy]
    respond_to :js, only: [:create]

    def index
      if current_user.has_role?('admin')
        @disciplines = Discipline.all
      else
        @disciplines = Discipline.joins(role_users: :role).where(role_users: { user_id: current_user.id, roles: { name: 'moderator' } })
      end
    end

    def show
      @materials = @discipline.materials
    end

    def new
        @discipline = Discipline.new
        # По-хорошему нужно для добавления сразу дисциплин
        # @material = Material.new
    end

    def create
      @discipline = Discipline.new(discipline_params)
      if @discipline.save
        moderator = current_user.get_role_user('moderator')
        if !moderator.nil?
          @discipline.role_users << moderator
        end
        redirect_to moderator_disciplines_path, notice: 'Дисциплина успешно создана!'
      else
        # Не используется, но мб есть смысл здесь сразу делать запрос, а не в бд
        # @available_materials = Material.all
        redirect_to request.referer, alert: "Имя должно быть уникальным"
      end
    end
    
    def update_order
      Rails.logger.info params[:ordered_ids].inspect
      params[:ordered_ids].each_with_index do |id, index|
        Material.find(id).update(order: index)
      end
      # Ответ сервера (например, статус 200 OK)
    end
  

    def edit
      @discipline = Discipline.find(params[:id])
      @materials = @discipline.materials
    end

    def update
      if @discipline.update(discipline_params)
        redirect_to moderator_discipline_path(@discipline), notice: 'Дисциплина успешно обновлена!'
      else
        @available_materials = Material.all
        redirect_to request.referer, alert: "Имя должно быть уникальным"
      end
    end

    def destroy
      @discipline.materials.destroy_all
      @discipline.destroy
      redirect_to moderator_disciplines_path, notice: 'Дисциплина успешно удалена!'
    end

    def detach_material
      @discipline = Discipline.find(params[:id])
      @material = @discipline.materials.find(params[:material_id])
      @discipline.materials.destroy(@material)
    
      respond_to do |format|
        format.js
      end
    end


    private

      def check_access_to_discipline
        @discipline = Discipline.find(params[:id])
        redirect_to root_path, alert: 'Доступ запрещен' unless @discipline.role_users.exists?(user_id: current_user.id, role_id: Role.find_by(name: 'moderator')&.id) || @is_admin
      end
    
      def discipline_params
        params.require(:discipline).permit(:name, :description, material_ids: [])
      end
end
