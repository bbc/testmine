require 'spec_helper'

describe AggregateResultComparisonGroup do
  describe "adding a result" do

    before(:each) do

      @test = TestDefinition.find_or_create(
          name: 'Scanning item',
          node_type: 'Cucumber::Feature'
      )

      @world1 = World::SingleComponent.find_or_create(
          :component => "TestMite",
          :project   => "Titan",
          :version   => "1.2.3" )

      @world2 = World::SingleComponent.find_or_create(
          :component => "TestMite",
          :project   => "Titan",
          :version   => "1.2.4" )

      @run1 = Run.create( world: @world1, target: 'ubuntu' )
      @run2 = Run.create( world: @world1, target: 'osx' )
      @run3 = Run.create( world: @world2, target: 'ubuntu' )
      @run4 = Run.create( world: @world2, target: 'osx' )
      @run5 = Run.create( world: @world2, target: 'osx' )

      @result1 = Result.create(
          :test_definition_id => @test.id,
          :status => "pass",
          :run_id => @run1.id
      )

      @result2 = Result.create(
          :test_definition_id => @test.id,
          :status => "fail",
          :run_id => @run2.id
      )
      @result3 = Result.create(
          :test_definition_id => @test.id,
          :status => "fail",
          :run_id => @run3.id
      )
      @result4 = Result.create(
          :test_definition_id => @test.id,
          :status => "fail",
          :run_id => @run4.id
      )
      @result5 = Result.create(
          :test_definition_id => @test.id,
          :status => "pass",
          :run_id => @run5.id
      )
    end

    it "produces 1 comparison set from results from 2 worlds" do
      comparison = AggregateResultComparisonGroup.populate( :reference_world_id => @world1.id, :primary_world_id => @world2.id, :target => 'osx' )
      expect( comparison.results.count ).to eq 1
      expect( comparison.results.first ).to be_a AggregateResultComparison
      expect( comparison.status ).to eq "newpass"
    end

    it "contains aggregates from two different worlds" do
      comparison = AggregateResultComparisonGroup.populate( :reference_world_id => @world1.id, :primary_world_id => @world2.id, :target => 'osx' )

      expect(comparison.results.first.status).to eq "newpass"
      expect(comparison.results.first.reference.world.id).not_to eq comparison.results.first.primary.world.id

      expect(comparison.results.first.reference.status).not_to eq comparison.results.first.primary.status
    end

  end

end
