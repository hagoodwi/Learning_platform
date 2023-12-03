class MaterialsController < ApplicationController
  before_action :set_discipline, only: [:new, :create, :_new_modal]

  def new
    @material = @discipline.materials.build
    @discipline = Discipline.find(params[:discipline_id])
  end

  def index
    @materials = Material.all
  end

  def create
    @material = @discipline.materials.build(material_params)
    if params[:material][:file].nil?
      redirect_to request.referer, alert: 'Пожалуйста, выберите файл.'
    elsif @material.save
      create_material_access(@material, params[:material])
      respond_to do |format|
        format.js
      end
    else
      redirect_to request.referer, alert: 'Ошибка при добавлении материала.'
    end
  end

  def show
    @material = Material.find(params[:id])
    @material_access = MaterialAccess.find_or_initialize_by(material_id: @material.id)
  end

  
  def update_access
    @material = Material.find(params[:id])
    @material_access = @material.material_access || @material.build_material_access
  
    if @material_access && @material_access.update(material_access_params)
      respond_to do |format|
        format.js { render :update_access_success }
      end
    else
      respond_to do |format|
        format.js { render :update_access_error, status: :unprocessable_entity }
      end
    end
  end


  private

  def material_access_params
    params.require(:material_access).permit(:always_open, :start_time, :end_time)
  end

  def set_discipline
    @discipline = Discipline.find(params[:discipline_id])
  end

  def create_material_access(material, params)
    visible_for_a_period = params[:visible_for_a_period] == '1'
  
    MaterialAccess.create!(
      material_id: material.id,
      always_open: !visible_for_a_period,
      start_time: visible_for_a_period ? params[:start_time] : nil,
      end_time: visible_for_a_period ? params[:end_time] : nil
    )
  end

  def material_params
    params.require(:material).permit(:file, :name, :discipline_id)
  end
end