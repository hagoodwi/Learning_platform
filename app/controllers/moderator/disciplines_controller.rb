class Moderator::DisciplinesController < ModeratorController
    before_action :set_discipline, only: [:show, :edit, :update, :destroy]
    respond_to :js, only: [:create]

    def index
        @disciplines = Discipline.all
    end

    def new
        @discipline = Discipline.new

        # По-хорошему нужно для добавления сразу дисциплин
        # @material = Material.new
    end
    
    def create
      @discipline = Discipline.new(discipline_params)
    
      if @discipline.save
        redirect_to moderator_disciplines_path, notice: 'Дисциплина успешно создана!'
      else
        # @available_materials = Material.all
        redirect_to request.referer, alert: "Имя должно быть уникальным"
      end
    end

    private
  
    def set_discipline
      @discipline = Discipline.find(params[:id])
    end
  
    def discipline_params
      params.require(:discipline).permit(:name, :description, material_ids: [])
    end
end
