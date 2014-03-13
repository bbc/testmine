require 'spec_helper'

describe Result do
  describe "adding a result" do

    before(:each) do

      @test = TestDefinition.find_or_create(
          name: 'Scanning item',
          node_type: 'Cucumber::Feature',
      )

      @world = World::SingleComponent.find_or_create(
          :component => "TestMite",
          :project   => "Titan",
          :version   => "1.2.3" )

      @run = Run.create( world: @world, target: 'x86_64' )
    end

    it "creates a result" do

      Result.create(
        :test_definition_id => @test.id,
        :status => "pass",
        :run_id => @run.id
      )

      @run.results.count == 1
      @run.results.first.status == "passed"
    end

  end



end
