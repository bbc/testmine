class RunsController < ApplicationController
  def show
    @run = Run.find(params[:id])
  end
end
