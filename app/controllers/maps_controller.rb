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

  def kml_update
    @map = current_user.maps.find(params[:id])
    @map.kml_update

    redirect_to maps_path, :notice => 'KML data refreshed'
  end

  def regenerate
    @map = current_user.maps.find(params[:id])
    @map.js_generate
    @map.css_generate

    redirect_to map_path(@map), :notice => 'JS/CSS regenerated'
  end


end
