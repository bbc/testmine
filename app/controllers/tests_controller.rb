class TestsController < ApplicationController
  def show
    @test = TestDefinition.find(params[:id])
    
    if params[:target]
      #TODO Ought to limit what we get back to a specific target
    end
    
    results = Result.includes( :run, :children ).where(:test_definition_id => params[:id]).limit(100)
    
    @results_hash = results.group_by { |r| r.run.target }
    
  end
end
