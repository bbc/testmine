# world_id, parent_result_id, test_definition_id, target
# best_result_id, status, pass_count, fail_count, error_count, notrun_count

class AggregateResultGroup
  attr_accessor :results, :target, :world

  #
  # Create an AggregateResultGroup
  # Requires: world_id
  #           target
  # Construncts a result-like object that contains a whole bunch of results
  #
  def self.populate( args )
    world_id = args[:world_id] or raise "Need to provide a world_id"
    
    world = World.find(world_id)
    target = args[:target] or raise "Need to provide  a target"
    
    tags = args[:tags]

    results_by_test_id = Result.joins(:run).where(:parent_id => nil,
                                       :runs => {:target => target, :world_id => world_id}).group_by { |r| r.test_definition_id }

    
    aggregates = results_by_test_id.values.collect do |results|
      AggregateResult.new( results[0].test_definition, world, results, target, tags )
    end
    
    if !tags.empty?
      aggregates = aggregates.select { |ar| ar.child_tags.any? { |t| tags.include?(t) } } 
    end
    
    AggregateResultGroup.new( :results => aggregates, :world => world, :target => target )
  end
  
  #
  # Construct the object
  #
  def initialize( args )
    @world = args[:world]
    @results = args[:results]
    @target = args[:target]
    @count = {}
  end

  # Get a list of tags that all the test_definitions in this aggregate are tagged with
  def tags
    results.collect { |r| r.child_tags }.flatten.uniq
  end

  #
  # Return the overall status of the target
  #
  def status
    if results.empty?
      'notrun'
    else
      Result.summary_status(results.collect { |r| r.status } )
    end
  end

  #
  # Counts the statuses of all the child elements
  #
  def count (status)
    if !@count[status]
      @count[status] = self.results.collect { |c| c.status == status.to_s }.count(true)
    end
    @count[status]
  end

end