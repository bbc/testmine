class WorldsController < ApplicationController
  def index
    @worlds = World.last(20).reverse
  end
  
  
  # world/search?hive_job_id=3000
  def search
    
    search_params = {}
    search_params[:hive_job_id] = params[:hive_job_id] if params[:hive_job_id]
    
    run = Run.where( search_params ).first
      
    world = run.world
    
    redirect_to "/worlds/#{world.id}"
  end

  def show
    @world = World.includes(:runs).find(params[:id].to_i)

    @runs = @world.runs
    aggregate_results = AggregateResult.find( :world_id => @world.id ).sort { |a,b|
      a.target + a.test_definition.name <=> b.target + b.test_definition.name
    }
    
    @aggregate_results_hash = aggregate_results.group_by { |i| i.target }
    
    @comparison_worlds = Run.group(:world).where(:world_id => @world.similar).limit(10).count
  end
  
  def aggregate_element
    @aggregate = AggregateResult.find( :world_id => params[:world_id].to_i,
                                       :test_definition_id => params[:test].to_i,
                                       :target => params[:target] ).first
    @target = params[:target]
    render layout: false
  end

  def compare
    @reference = World.find(params[:reference].to_i)
    @primary = World.find(params[:primary].to_i)

    comparisons = AggregateResultComparison.find( params[:primary].to_i, params[:reference].to_i ).sort { |a,b|
      a.target + a.test_definition.name <=> b.target + b.test_definition.name
    }
    
    @comparisons_hash = comparisons.group_by { |i| i.target }
    
  end
   
  def comparison_element
    @comparison = AggregateResultComparison.find( params[:primary].to_i, params[:reference].to_i,
                                                  :test_definition_id => params[:test].to_i,
                                                  :target => params[:target] ).first
    @target = params[:target]
    render layout: false
  end
end
