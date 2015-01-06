require 'spec_helper'

describe AggregateResultGroup do
  describe "adding a result" do

    before(:each) do

      @test = TestDefinition.find_or_create(
          name: 'Scanning item',
          node_type: 'Cucumber::Feature'
      )

      @test2 = TestDefinition.find_or_create(
          name: 'Some other thing',
          node_type: 'Cucumber::Feature'
      )

      @world = World::SingleComponent.find_or_create(
          :component => "TestMite",
          :project   => "Titan",
          :version   => "1.2.3" )

      @run1 = Run.create( world: @world, target: 'osx' )
      @run2 = Run.create( world: @world, target: 'osx' )
      @run3 = Run.create( world: @world, target: 'ubuntu' )

      @result1 = Result.create(
          :test_definition_id => @test.id,
          :status => "fail",
          :run_id => @run1.id
      )
      @result2 = Result.create(
          :test_definition_id => @test.id,
          :status => "pass",
          :run_id => @run2.id
      )
      @result3 = Result.create(
          :test_definition_id => @test.id,
          :status => "pass",
          :run_id => @run3.id
      )
      @result4 = Result.create(
          :test_definition_id => @test2.id,
          :status => "fail",
          :run_id => @run3.id
      )


    end

    it "aggregates results for a world and target" do
      aggregate_group_1 = AggregateResultGroup.populate( :world_id => @world.id, :target => 'osx' )
      expect(aggregate_group_1.results.count).to eq 1
      
      aggregate_group_2 = AggregateResultGroup.populate( :world_id => @world.id, :target => 'ubuntu' )
      expect(aggregate_group_2.results.count).to eq 2
    end

    it "produces summary counts of child results" do
      aggregate_results_1 = AggregateResultGroup.populate( :world_id => @world.id, :target => 'osx' )
      aggregate_results_2 = AggregateResultGroup.populate( :world_id => @world.id, :target => 'ubuntu' )

      expect(aggregate_results_1.count('pass')).to eq 1
      expect(aggregate_results_1.count('fail')).to eq 0
      expect(aggregate_results_1.count('error')).to eq 0

      expect(aggregate_results_2.count('pass')).to eq 1
      expect(aggregate_results_2.count('fail')).to eq 1
      expect(aggregate_results_2.count('error')).to eq 0      
      
    end
    
    it "produces a summery status for child results" do
      aggregate_results_1 = AggregateResultGroup.populate( :world_id => @world.id, :target => 'osx' )
      aggregate_results_2 = AggregateResultGroup.populate( :world_id => @world.id, :target => 'ubuntu' )

      expect(aggregate_results_1.status).to eq 'pass'
      expect(aggregate_results_2.status).to eq 'fail'
      
    end
    

  end

end
