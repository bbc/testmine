class TestsController < ApplicationController
  def show
    @test = TestDefinition.find(params[:id])
    
    if params[:target]
      #TODO Ought to limit what we get back to a specific target
    end
    
    @results = Result.where(:test_definition_id => params[:id]).limit(20)
    
  end
end
