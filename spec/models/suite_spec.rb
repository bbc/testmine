require 'spec_helper'

describe Suite do
  describe "find_or_create" do

    it "creates a suite" do
      
      suite = Suite.find_or_create(
        project:       'Titan',
        name:          'Cucumber features',
        runner:        'Ruby Cucumber',
        description:   'Feature files for the Titan project',
        documentation: "Long description of what's going on",
        url:           'https://www.github.com/bbc-test',
        repo:          'https://www.github.com/bbc-test/titan'
      )
      
      suite.project.should == 'Titan'
      suite.name.should == "Cucumber features"
      suite.runner.should == 'Ruby Cucumber'
      suite.description.should be_a String
      suite.url.should be_a String
      suite.repo.should be_a String
      
    end
    
  end
end
