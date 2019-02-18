class TestsController < ApplicationController
  def show
    @test = TestDefinition.find(params[:id])
    
    results = Result.order(:created_at => :desc).includes( :children, :run => [ :world ]).where(:test_definition_id => params[:id]).limit(200)
    
    @results_hash = results.group_by { |r| r.run.target }
    
  end
  
  def history
    @test_definition_id = params[:id].to_i
    @target = params[:target]
    @histories = ResultHistory.find_for_all_targets(:test_definition_id => @test_definition_id )

    @grouped_results = ResultHistory.group_by_commit(@histories)

    @test = @histories[@target].test_definition
  end
end
