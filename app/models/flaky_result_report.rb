class FlakyResultReport

  def self.populate( args )
                    
    primary_world_id = args[:world_id] or raise "Need to provide a primary world id"
    primary_world = World.find(primary_world_id)
    target = args[:target]
    
    tags = args[:tags]
    
    primary_results_by_test = Result.unscoped
                                    .includes(:test_definition => :tags,
                                      :children => [
                                      :children => [:test_definition => :tags],
                                      :test_definition => :tags ])
                                    .joins(:run)
                                    .where(:parent_id => nil, :runs => {:target => target, :world_id => primary_world_id})
                                    .last(500)
                                    .group_by { |r| r.test_definition }

    tests = primary_results_by_test.keys
    
    aggregates = tests.map do |test|
      primary_results = primary_results_by_test[test] || []
      AggregateResult.new( test, primary_world, primary_results, target, tags )
    end

    AggregateResultGroup.new( :results => aggregates, :world => primary_world, :target => target )
  end

end
