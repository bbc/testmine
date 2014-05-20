class WorldsController < ApplicationController
  def index
    @worlds = World.last(20).reverse
  end

  def show
    @world = World.find(params[:id].to_i)
    @runs = @world.runs
    @aggregate_results = AggregateResult.find( :world_id => @world.id ).sort { |a,b|
      a.target + a.test_definition.name <=> b.target + b.test_definition.name
    }
    @comparison_worlds = @world.similar
  end

  def compare
    @reference = World.find(params[:reference].to_i)
    @primary = World.find(params[:primary].to_i)

    @comparisons = AggregateResultComparison.find( params[:primary].to_i, params[:reference].to_i ).sort { |a,b|
      a.target + a.test_definition.name <=> b.target + b.test_definition.name
    }
  end
  
  def comparison_element
    @comparison = AggregateResultComparison.find( params[:primary].to_i, params[:reference].to_i,
                                                  :test_definition_id => params[:test].to_i,
                                                  :target => params[:target] ).first
    render layout: false
  end
end
