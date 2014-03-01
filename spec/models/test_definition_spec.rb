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
      
      test_definition.name.should be_a String
      test_definition.node_type.should be_a String
      test_definition.description.should be_a String
      test_definition.file_name.should be_a String
      test_definition.line.should be_a Fixnum
    end

    it "creates 2 definitions for a suite" do

      suite = Suite.find_or_create(
          project:       'Titan',
          name:          'Cucumber features',
          runner:        'Ruby Cucumber',
          description:   'Feature files for the Titan project',
          documentation: "Long description of what's going on",
          url:           'https://www.github.com/bbc-test',
          repo:          'https://www.github.com/bbc-test/titan'
      )

      suite.find_or_add_test_definition(
          name: 'Scanning item',
          node_type: 'Cucumber::Feature',
          description: 'Scanning an item',
          file_name: 'items.feature',
          line: 1
      )

      suite.find_or_add_test_definition(
          name: 'Showing total',
          node_type: 'Cucumber::Feature',
          description: 'Showing cart total',
          file_name: 'items.feature',
          line: 7
      )

      suite.tests.count.should == 2

    end

    it "creates definition and sub-definition for a suite" do

      suite = Suite.find_or_create(
          project:       'Titan',
          name:          'Cucumber features',
          runner:        'Ruby Cucumber',
      )

      test = suite.find_or_add_test_definition(
          name: 'Scanning things',
          node_type: 'Cucumber::Scenario',
      )

      test.suite.name.should == "Cucumber features"

      subtest = test.find_or_add_test_definition(
          name: 'Given something',
          node_type: 'Cucumber::Step',
      )

      subtest = test.find_or_add_test_definition(
          name: 'Then something',
          node_type: 'Cucumber::Step',
      )

      subtest.parent.name.should == "Scanning things"

      puts suite.inspect
      puts suite.tests.inspect
      puts suite.tests.first.children.inspect

      suite.tests.count.should == 1
      suite.tests.first.children.count.should == 2
    end



  end  

end
