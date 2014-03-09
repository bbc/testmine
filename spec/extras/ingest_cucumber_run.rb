require 'spec_helper'
require 'json'

describe IrIngestor do
  describe "ingesting a simple result" do

    before(:all) do
    @ir = {
      type: "ruby cucumber",
      started: Time.now.to_s,
      finished: Time.now.to_s,
      target: 'x86_64',
      user:   "anon",
      project: 'hive',
      world: {
        component: 'web_app',
        version: '0.2.1'
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
            "name" => "Basic scenario with background",
            "children" =>[
            {
              "type" => "Cucumber::Step",
              "name" => "Given something",
              "status" => "passed"
            },
            {
              "type" => "Cucumber::Step",
              "name" => "When something happens",
              "status" => "passed"
            },
            {
              "type" => "Cucumber::Step",
              "name" => "Then something else happens",
              "status" => "false"
            }
            ]
          }]
        }
      ]
    }.to_json

    end

    it "imports under a single result object" do

      run = IrIngestor.parse_ir(@ir)

      p run
    end


  end

end