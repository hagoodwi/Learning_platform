# controllers/disciplines_controller.rb
class DisciplinesController < ApplicationController
    before_action :set_discipline, only: [:show, :edit, :update, :destroy]
    respond_to :js, only: [:create]
  
    def index
      @disciplines = Discipline.all
    end
  
    def new
      @discipline = Discipline.new
      @material = Material.new
    end
  
    def create
      @discipline = Discipline.new(discipline_params)
  
      if @discipline.save
        redirect_to disciplines_path, notice: 'Дисциплина успешно создана!'
      else
        @available_materials = Material.all
        redirect_to request.referer, alert: "Имя должно быть уникальным"
      end
    end
  
    def show
      @available_materials = Material.all
    end
  
    def edit
      @discipline = Discipline.find(params[:id])
      @available_materials = @discipline.materials
    end
  
    def update
      if @discipline.update(discipline_params)
        redirect_to @discipline, notice: 'Дисциплина успешно обновлена!'
      else
        @available_materials = Material.all
        redirect_to request.referer, alert: "Имя должно быть уникальным"
      end
    end
  
    def destroy
        @discipline.materials.destroy_all
        @discipline.destroy
        redirect_to disciplines_path, notice: 'Дисциплина успешно удалена!'
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
  
    def set_discipline
      @discipline = Discipline.find(params[:id])
    end
  
    def discipline_params
      params.require(:discipline).permit(:name, material_ids: [])
    end
  end