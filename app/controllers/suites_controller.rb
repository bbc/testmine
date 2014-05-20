class SuitesController < ApplicationController
  def index
    @suites = Suite.last(200)
  end
  
  def show
    @suite = Suite.find( params[:id] )
    
    test_ids = TestDefinition.where( :suite_id => params[:id], :parent_id => nil ).map { |t| t.id }
    run_ids = Result.where( :test_definition_id => test_ids ).map { |r| r.run_id }.uniq
    world_ids = Run.find( run_ids ).map { |r| r.world_id }.uniq
    
    @worlds = World.find( world_ids ).reverse
  end
end
