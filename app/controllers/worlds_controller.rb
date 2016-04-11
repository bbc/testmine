class WorldsController < ApplicationController
  def index
    @worlds = World.last(100).reverse
  end
  
  
  # worlds/search?hive_job_id=3000
  def search
    
    @search_params = {}

    if params[:hive_job_id]
      @search_params[:hive_job_id] = params[:hive_job_id]
      runs = Run.where( @search_params )
    
      if runs && !runs.empty?
        world = runs.first.world
        redirect_to "/worlds/#{world.id}"
      end
    
    elsif params[:version]
      
      @search_params[:project] = params[:project] if params[:project]
      @search_params[:component] = params[:component] if params[:component]
      @search_params[:version] = params[:version]
      
      world = World.where( @search_params ).last
      
      if world
        redirect_to "/worlds/#{world.id}"
      end
      
      
    end
  end

  def show
    @world = World.includes(:runs).find(params[:id].to_i)

    @runs = @world.runs.reverse
    
    @tag = params[:tag] if (params[:tag] && params[:tag].length > 0)
    
    @targets = Run.where( :world_id => @world.id ).pluck('DISTINCT target')
    
    @comparison_worlds = World.similar(@world).includes(:runs)
  end

  def aggregate_group_element
    
    @target = params[:target]
    @world_id = params[:world_id].to_i
    @tag = params[:tag] if (params[:tag] && params[:tag].length > 0)
    tags = []
    tags.push @tag if @tag
 
    @results = AggregateResultGroup.populate( :world_id => @world_id,
                                              :target => @target,
                                              :tags => tags )
    
    @tags = @results.tags

    render layout: false
  end


  def compare
    reference_world_id = params[:reference].to_i
    primary_world_id = params[:primary].to_i
    @reference_world = World.find(reference_world_id)
    @primary_world = World.find(primary_world_id)
    
    @targets = Run.where( :world_id => [reference_world_id, primary_world_id] ).pluck('DISTINCT target')
  end
   
  def comparison_group_element
    @target = params[:target]
    @primary_world_id = params[:primary].to_i
    @reference_world_id = params[:reference].to_i
    @reference_world = World.find(params[:reference].to_i)
    @primary_world = World.find(params[:primary].to_i)
    @tag = params[:tag] if (params[:tag] && params[:tag].length > 0)
    tags = []
    tags.push @tag if @tag
    
    @results = AggregateResultComparisonGroup.populate( :primary_world_id => @primary_world_id,
                                                        :reference_world_id => @reference_world_id,
                                                        :target => @target,
                                                        :tags => tags )
    render layout: false
  end
  
  
end
