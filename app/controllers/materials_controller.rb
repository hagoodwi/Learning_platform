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
      respond_to do |format|
        format.js
      end
    else
      redirect_to request.referer, alert: 'Ошибка при добавлении материала.'
    end
  end

  def show
    @material = Material.find(params[:id])
  end

  private

  def set_discipline
    @discipline = Discipline.find(params[:discipline_id])
  end

  def material_params
    params.require(:material).permit(:file, :name, :discipline_id)
  end
end