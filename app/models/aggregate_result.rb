# world_id, parent_result_id, test_definition_id, target
# best_result_id, status, pass_count, fail_count, error_count, notrun_count

class AggregateResult
  attr_accessor :results, :target, :world, :test_definition, :filter_tags

  # Returns an array of AggregateResult children
  def children
    if !@children
      child_result_set = @results.map { |r| r.children }
      @children = AggregateResult.process_children(child_result_set.flatten, world, target, self.inherited_tags, filter_tags)
    end
    @children
  end

  def self.process_children( results, world, target, tags, filter_tags )
    results_by_test = results.group_by { |r| r.test_definition }
    
    filter_tags = [] if !tags.empty? && tags.any? { |t| filter_tags.include?(t) }
    
    aggregates = results_by_test.collect { |test, result| AggregateResult.new( test, world, result, target, filter_tags ) }
    
    if !filter_tags.empty?
      aggregates = aggregates.select { |ar| ar.tags.any? { |t| filter_tags.include?(t) } } 
    end
    aggregates
  end  

  def best
    if !@best
      if !results || results.empty?
        @best = Result.new(:status => "notrun")
      else
        if results.last.status =='pass'
          @best = results.last
        else
          sorted_results = results.sort { |a, b| a.status_score <=> b.status_score }
          @best = sorted_results.last
        end
      end
    end
    @best
  end

  #
  # Given a Result, or an array of Results, creates an AggregateResult
  # object.
  #
  def initialize( _test_definition, _world, _result, _target, _filter_tags )
    @test_definition = _test_definition
    @world = _world
    @results = _result
    @filter_tags = _filter_tags
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
    if !@status
      if self.best.status
        @status = self.best.status
      # If a status hasn't been set, need to work it out
      else
        @status = Result.summary_status(children.collect {|r| r.status})
      end
    end
    @status
  end

  # Counts the statuses of all the child elements
  def count(status)
    if !@count[status.to_sym]
      self.children.each { |c| @count[c.status.to_sym] = @count[c.status.to_sym].to_i + 1 }
      @count.default = 0
    end
    @count[status.to_sym]
  end
  
  def inherited_tags
    if !@inherited_tags
      @inherited_tags = self.test_definition.specific_tags
    end
    @inherited_tags
  end
    
  def tags
    if !@tags
      all = self.test_definition.specific_tags
      if self.test_definition.node_type !~ /::Step$/ && self.children 
        all += self.children.collect { |c| c.tags }
      end
      @tags = all.flatten.uniq
    end
    @tags
  end
  
end
