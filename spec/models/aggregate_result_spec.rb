require 'spec_helper'

describe AggregateResult do
  describe "adding a result" do

    before(:each) do

      @test = TestDefinition.find_or_create(
          name: 'Scanning item',
          node_type: 'Cucumber::Feature'
      )

      @world = World::SingleComponent.find_or_create(
          :component => "TestMite",
          :project   => "Titan",
          :version   => "1.2.3" )

      @run1 = Run.create( world: @world, target: 'ubuntu' )
      @run2 = Run.create( world: @world, target: 'osx' )
      @run3 = Run.create( world: @world, target: 'osx' )

      @result1 = Result.create(
          :test_definition_id => @test.id,
          :status => "fail",
          :run_id => @run1.id
      )

      @result2 = Result.create(
          :test_definition_id => @test.id,
          :status => "fail",
          :run_id => @run2.id
      )
      @result3 = Result.create(
          :test_definition_id => @test.id,
          :status => "pass",
          :run_id => @run3.id
      )

    end

    it "produces 2 aggregate sets from 3 results" do
      aggregate_results = AggregateResult.find( :world_id => @world.id )
      aggregate_results.count.should == 2
      aggregate_results.collect { |ar| ar.results.count }.should == [1,2]
    end

    it "produces 2 aggregates, one passes, one fails" do
      aggregate_results = AggregateResult.find( :world_id => @world.id )
      aggregate_results.first.status.should == "fail"
      aggregate_results.second.status.should == "pass"
    end

  end

end
