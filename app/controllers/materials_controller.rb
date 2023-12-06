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
    if @material.name.blank? && params[:material][:file].respond_to?(:original_filename)
      @material.name = params[:material][:file].original_filename
    end
    if params[:material][:file].nil?
      redirect_to request.referer, alert: 'Пожалуйста, выберите файл.'
    elsif @material.save
      create_material_access(@material, params[:material])
      redirect_to request.referer, notice: 'Материал загружен'   
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
  
    # Проверим, нужно ли обновлять временные параметры
    if !@material_access.always_open
      # Теперь можно обновлять start_time_material_access и end_time_material_access
      if @material_access.update(material_access_params)
        respond_to do |format|
          format.js { render :update_access_success }
        end
      else
        respond_to do |format|
          format.js { render :update_access_error, status: :unprocessable_entity }
        end
      end
    else
      # Если always_open, просто обновляем флаг
      if @material_access.update(material_access_params)
        respond_to do |format|
          format.js { render :update_access_success }
        end
      else
        respond_to do |format|
          format.js { render :update_access_error, status: :unprocessable_entity }
        end
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
    start_time = params[:start_time]
    end_time = params[:end_time]
  
    if start_time.present? && end_time.present? && start_time.to_datetime >= end_time.to_datetime
      # Если start_time >= end_time, то выбросим исключение или обработаем ошибку в соответствии с вашими потребностями
      raise ArgumentError.new('Время начала должно быть раньше времени окончания')
    end
  
    if start_time.present? && end_time.present?
      always_open = false
    else
      always_open = true
      start_time = end_time = nil
    end
  
    MaterialAccess.create!(
      material_id: material.id,
      always_open: always_open,
      start_time: start_time,
      end_time: end_time
    )
  end
  
  def material_params
    params.require(:material).permit(:file, :name, :discipline_id)
  end
end