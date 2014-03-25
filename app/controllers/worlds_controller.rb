class WorldsController < ApplicationController
  def index
    @worlds = World.last(20)
  end

  def show
    @world = World.find(params[:id].to_i)
    @runs = @world.runs
    @aggregate_results = AggregateResult.find( :world_id => @world.id )
    @comparison_worlds = @world.similar
  end

  def compare
    @reference = World.find(params[:reference].to_i)
    @primary = World.find(params[:primary].to_i)

    @comparisons = AggregateResultComparison.find( params[:primary].to_i, params[:reference].to_i )

  end
end