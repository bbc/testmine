class WorldsController < ApplicationController
  def index
    @worlds = World.last(20)
  end

  def show
    @world = World.find(params[:id])
    @runs = @world.runs
  end
end