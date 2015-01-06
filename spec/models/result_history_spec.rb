require 'spec_helper'

describe ResultHistory do
  describe "Complex result sets" do

    before(:all) do
      @world = World::SingleComponent.find_or_create(
          :component => "TestMite",
          :project   => "Titan",
          :version   => "1.2.3" )

      @historic_runs = [
        Run.create( world: @world, target: 'x86_64' ),
        Run.create( world: @world, target: 'x86_64' ),
        Run.create( world: @world, target: 'x86_64' )
      ]
      
      @historic_parent = TestDefinition.find_or_create( name: 'Top' )
      @historic_test_definitions = [
        TestDefinition.find_or_create( name: 'Child1', parent_id: @historic_parent.id ),
        TestDefinition.find_or_create( name: 'Child2', parent_id: @historic_parent.id  ),
        TestDefinition.find_or_create( name: 'Child3', parent_id: @historic_parent.id  )
      ]
      
      @historic_runs.each do |r|
        
        parent = Result.create( test_definition_id: @historic_parent.id, status: "pass", run_id: r.id )
        @historic_test_definitions.each do |t|
          Result.create( test_definition_id: t.id, status: "pass", run_id: r.id, parent_id: parent.id )
        end
      end
      
      @result_history = ResultHistory.find( :test_definition_id => @historic_parent.id, :target => 'x86_64' )
      
    end
    
    it "has a test_defintion" do
      expect(@result_history.test_definition).to eq @historic_parent
    end

    it "has a primary result" do
      expect( @result_history.primary_result ).to be_a Result
    end
    
    it "has a primary result that is the latest result" do
      expect( @result_history.primary_result ).to eq Result.where(:parent_id => nil).last
    end
    
    it "has reference results" do
      expect( @result_history.reference_results.count ).to be >= 2
      expect( @result_history.reference_results.first ).to be_a Result
    end
    
    it "has child test definitions that correspond to the primary result" do
      expect( @result_history.child_test_definitions ).to be_a Array
      expect( @result_history.child_test_definitions.first ).to be_a TestDefinition
    end
    
    it "has a child result for the first test defintion" do
      test_definition = @result_history.child_test_definitions[0]
      expect( @result_history.primary_child(test_definition)).to eq @result_history.primary_children[0]
    end

  end



end
