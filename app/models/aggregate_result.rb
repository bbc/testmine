# world_id, parent_result_id, test_definition_id, target
# best_result_id, status, pass_count, fail_count, error_count, notrun_count

class AggregateResult
  attr_accessor :results, :target, :world, :test_definition

  # Returns an array of AggregateResult children
  def children
    if !@children
      child_result_set = @results.map { |r| r.children }
      @children = AggregateResult.process_children(child_result_set.flatten, world, target)
    end
    @children
  end

  def self.process_children( results, world, target )
    results_by_test = results.group_by { |r| r.test_definition }
    results_by_test.collect { |test, result| AggregateResult.new( test, world, result, target ) }
  end  


  def best
    if !@best
      if !results || results.empty?
        @best = Result.new(:status => "notrun")
      else
        sorted_results = results.sort { |a, b| a.status_score <=> b.status_score }
        @best = sorted_results.last
      end
    end
    @best
  end

  #
  # Given a Result, or an array of Results, creates an AggregateResult
  # object.
  #
  def initialize( _test_definition, _world, _result, _target )
    @test_definition = _test_definition
    @world = _world
    @results = _result
    if @results && @results.count > 0 && @results.first.class != Result
      raise "Not an array of Results #{caller}"
    end
    
    @target = _target
    @count = {}
  end

  #
  # Methods to make this look more like a Result object
  #

  def status
    if self.best.status
      self.best.status
    # If a status hasn't been set, need to work it out
    else
      Result.summary_status(children.collect {|r| r.status})
    end
  end

  # Counts the statuses of all the child elements
  def count (status)
    if !@count[status]
      @count[status] = self.children.collect { |c| c.status == status.to_s }.count(true)
    end
    @count[status]
  end

end