class WorldsController < ApplicationController
  def index
    @worlds = World.last(20)
  end
end
