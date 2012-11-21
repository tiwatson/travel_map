class MapsController < ApplicationController
  load_and_authorize_resource

  def show
    @map = current_user.maps.find(params[:id])
  end

  def create
    @map = current_user.maps.create(params[:map])
    if @map.save
      redirect_to @map
    else
      render :new
    end
  end

  def edit
    @map = current_user.maps.find(params[:id])
  end

  def update 
    @map = current_user.maps.find(params[:id])
    if @map.update_attributes(params[:map])
      redirect_to maps_path, :notice => 'Map updated'
    else
      render :edit
    end
  end

end
