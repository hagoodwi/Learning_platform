class MaterialsController < ApplicationController
  def new
    @material = Material.new
  end

  def create
    @material = Material.create!(material_params)
    if @material.save
      redirect_to @material, notice: 'Материал успешно создан.'
    else
      render :new
    end
  end

  def show
    @material = Material.find(params[:id])
  end

  private

  def material_params
    params.require(:material).permit(:file,:name,:add_date)
  end
end
