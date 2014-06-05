class AggregateResultComparison
  attr_accessor :primary, :reference, :test_definition, :target

  #
  # Given two world ids, generate an array of comparison objects
  # You can further restrict by providing options, currently you can specify
  #   AggregateResultComparison( 1, 2 ) # Compare worlds 1 and 2, returning
  # only top level results
  #   AggregateResultComparison( 1, 2, :primary_parent_id => [44], :reference_parent_id => [55] )
  # Compare worlds 1 and 2,
  # returning only children of results 44 and 55
  def self.find( primary_world_id, reference_world_id, args = {})

    primary_parent_id   = args[:primary_parent_id]
    reference_parent_id = args[:reference_parent_id]
    test_definition_id  = args[:test_definition_id]

    primary_world = World.includes(:runs).find( primary_world_id)
    reference_world = World.includes(:runs).find( reference_world_id)
    
    target = args[:target]

      primary_aggregates = AggregateResult.find( :world_id => primary_world_id,
                                                 :parent_id => primary_parent_id,
                                                 :target => target,
                                                 :test_definition_id => test_definition_id )
    
      reference_aggregates = AggregateResult.find( :world_id => reference_world_id,
                                                   :parent_id => reference_parent_id,
                                                   :target => target,
                                                   :test_definition_id => test_definition_id )

    hash = [ primary_aggregates, reference_aggregates ].flatten.reduce({}) do |h, a|
      
      key = a.test_definition_id.to_s + '-' + a.target.to_s
      if h.has_key?(key)
        h[key][a.world.id] = a
        h[key][:test_definition] = a.test_definition if a.test_definition
        h[key][:target] = a.target
      else
        h[key] = { a.world.id => a }
        h[key][:test_definition] = a.test_definition if a.test_definition
        h[key][:target] = a.target
      end
      h
    end

    hash.values.collect do |a|
      primary_aggregate = a[primary_world_id]
      reference_aggregate = a[reference_world_id]

      AggregateResultComparison.new( primary_world, reference_world, a[:test_definition], a[:target],
                                     primary_aggregate, reference_aggregate)
    end
  end

  def initialize( primary_world, reference_world,  test_def, target, primary_aggregate_result, reference_aggregate_result )
    @primary = primary_aggregate_result
    @reference = reference_aggregate_result
    @test_definition = test_def
    @target = target

    if !@primary
      @primary = AggregateResult.new( @test_definition, primary_world, [] )
    end

    if !@reference
      @reference = AggregateResult.new( @test_definition, reference_world, [] )
    end
  end

  # Return the comparison status for the primary world
  def status
    if !@status
      status = @primary.status
      if @primary.status == "pass" and @reference.status != "pass"
        status = "newpass"
      elsif @reference.status == "pass" and @primary.status == "fail"
        status = "regres"
      end

      if status.match("pass") && @primary.children.count < @reference.children.count
        status = "notrun"
      end

      if status == "pass" && @primary.children.count > @reference.children.count
        status = "newpass"
      end

      @status = status
    end
    @status
  end

  # Do primary and reference results differ
  def diff
    @primary.status != @reference.status || @primary.children.count != @reference.children.count
  end

  def children
    if !@children
      @children = AggregateResultComparison.find( primary.world.id, reference.world.id,
                                    :primary_parent_id => primary.results.map {|r| r.id },
                                    :reference_parent_id => reference.results.map {|r| r.id},
                                    :target => target)
    end
    @children
  end

end