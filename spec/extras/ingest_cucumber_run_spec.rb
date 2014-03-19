require 'spec_helper'
require 'json'

describe IrIngestor do
  describe "ingesting a simple result" do

    before(:all) do
    @ir = {
      type: "ruby cucumber",
      started: Time.now-20,
      finished: Time.now.to_s,
      target: 'x86_32',
      project: 'hive',
      world: {
        component: 'web_app',
        version: '0.2.2'
      },
      project: "hive",
      suite: "cucumber",
      results: [
        {
          "file" => "features/simple_feature.feature",
          "line" => 2,
          "type" =>"Cucumber::Feature",
          "name" =>"Background steps",
          "description" => "As a user\nI want results!",
          "children" => [
          {
            "file" => "features/simple_feature.feature",
            "line" => 14,
            "type" => "Cucumber::Scenario",
            "name" => "Deleted scenario",
            "children" =>[
            {
              "type" => "Cucumber::Step",
              "name" => "Given something",
              "status" => "pass"
            },
            {
              "type" => "Cucumber::Step",
              "name" => "When something happens",
              "status" => "pass"
            },
            {
              "type" => "Cucumber::Step",
              "name" => "Then something else happens",
              "status" => "fail"
            }
            ]
          }]
        }
      ]
    }.to_json

    end

    it "imports under a single result object" do

      run = IrIngestor.parse_ir(@ir)

      run.results.count.should == 5
      run.top_level_results.count.should == 1
      run.top_level_results.first.status.should == "fail"
    end
  end

end