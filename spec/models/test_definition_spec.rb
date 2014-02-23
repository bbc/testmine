require 'spec_helper'

describe TestDefinition do
  describe "find_or_create" do

    it "creates a test definition" do
      
      test_definition = TestDefinition.find_or_create(
        name: 'Scanning item',
        node_type: 'Cucumber::Feature',
        description: 'Scanning an item',
        file_name: 'items.feature',
        line: 1
      )
      
      suite.name.should be_a String
      suite.node_type.should be_a String
      suite.description.should be_a String
      suite.file_name.should be_a String
      suite.line.should be_a Fixnum
    end
    
  end  

end
