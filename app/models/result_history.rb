class ResultHistory
  
  attr_accessor :test_definition
  attr_accessor :primary_result
  attr_accessor :reference_results #array of reference 

  def self.find(args)
    
    # First identify the test_definition
    test_definition_id = args[:test_definition_id] or raise "Need to provide a test definition id"
    target = args[:target] or raise "Need to provide a target"
    
    test_definition = TestDefinition.find( test_definition_id )
    
    results = Result.joins(:run).where( :test_definition_id => test_definition_id, :runs => { :target => target } ).last(20).reverse
    ResultHistory.new( test_definition, results.shift, results )
  end
  
  def self.find_for_recent_targets(args)

    # First identify the test_definition
    test_definition_id = args[:test_definition_id] or raise "Need to provide a test definition id"
    target = args[:target]

    # Next derive recent targets...
    targets = Run.joins(:results => :test_definition).where( :results => {:test_definition_id => test_definition_id} ).limit(200).order('runs.id DESC').pluck('DISTINCT runs.target' )
    targets.push(target).uniq! if target
    
    # Finally find the results
    targets.reduce({}) { |h, t| h[t] = ResultHistory.find( args.merge({:target=>t}) ); h }
  end
  
  def initialize(test_definition, primary, reference)
    @test_definition = test_definition
    @primary_result = primary
    @reference_results = reference
  end

  def primary_children
    @primary_result.children
  end
  
  def child_test_definitions
    self.primary_children.collect { |c| c.test_definition } 
  end
  
  def primary_child(test_definition)
    self.primary_children.detect { |c| c.test_definition.id == test_definition.id }
  end
  
  def reference_child(test_definition, i)
    if reference_results[i]
      reference_results[i].children.detect { |r| r.test_definition.id == test_definition.id }
    end
  end
  
end