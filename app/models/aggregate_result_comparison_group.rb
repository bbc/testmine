class AggregateResultComparisonGroup
  attr_accessor :primary_world, :reference_world, :results, :target



  def self.populate( args )
                    
    primary_world_id = args[:primary_world_id] or raise "Need to provide a primary world id"
    reference_world_id = args[:reference_world_id] or raise "Need to provide a reference world id"
    primary_world = World.find(primary_world_id)
    reference_world = World.find(reference_world_id)
    target = args[:target]
    
    
    primary_results_by_test = Result.joins(:run).where(:parent_id => nil,
      :runs => {:target => target, :world_id => primary_world_id}).group_by { |r| r.test_definition }

    reference_results_by_test = Result.joins(:run).where(:parent_id => nil,
      :runs => {:target => target, :world_id => reference_world_id}).group_by { |r| r.test_definition }
     
    tests = primary_results_by_test.keys.concat(reference_results_by_test.keys).uniq
    
    aggregates = []
    tests.each do |test|
      primary_results = primary_results_by_test[test] || []
      reference_results = reference_results_by_test[test] || []
      
      primary_aggregate = AggregateResult.new( test, primary_world, primary_results, target )
      reference_aggregate = AggregateResult.new( test, reference_world, reference_results, target )
      
      aggregates.push(AggregateResultComparison.new( primary_world, reference_world, test, target,
                                     primary_aggregate, reference_aggregate) )
    end

    AggregateResultComparisonGroup.new( :primary_world => primary_world,
                                        :reference_world => reference_world,
                                        :target => target,
                                        :results => aggregates )
  end

  def initialize( args )
    @primary_world = args[:primary_world]
    @reference_world = args[:reference_world]
    @results = args[:results]
    @target = args[:target]
    @count = {}
  end
  
  #
  # Return the overall status of the target
  #
  def status
    AggregateResultComparisonGroup.summary_status(results)
  end
  
  def diff
   results.collect { |r| r.diff }.any? { |v| v == true }
  end
  
  
  def self.summary_status(results)
    statuses = results.collect { |r| r.status }

    resulting_status = "error"
    resulting_status = "pass"   if statuses.count("pass") > 0
    resulting_status = "newpass"   if statuses.count("newpass") > 0
    resulting_status = "notrun" if statuses.count("notrun") > 0
    resulting_status = "fail"   if statuses.count("fail") > 0
    resulting_status = "regres"   if statuses.count("regres") > 0

    resulting_status
  end

end
