class FlakyTestController < ApplicationController
  def show
    @world = World.includes(:runs).find(params[:world_id].to_i)
    @target = Run.where( :world_id => @world.id ).pluck('DISTINCT target')[0]
    @tags = []

    @results = FlakyResultReport.populate( :world_id => @world.id,
                                           :target => @target,
                                           :tags => @tags )
    
  end
end
