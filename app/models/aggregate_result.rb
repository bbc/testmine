# world_id, parent_result_id, test_definition_id, target
# best_result_id, status, pass_count, fail_count, error_count, notrun_count

class AggregateResult
  attr_accessor :results, :world, :test_definition

  # Returns an array of AggregateResult objects
  # You can find aggregate results in a number of ways:
  #   AggregateResult.find( :world_id => 1234 )
  #   AggregateResult.find( :world_id => 1234, target => 'firefox' )
  #   AggregateResult.find( :world_id => 1234, :parent_id => parent_result_id)
  # Required params:
  #   :world_id
  # Optional params:
  #   :parent_id, :target, :test_definition_id
  def self.find( args )

    world_id = args[:world_id]
    parent_id = args[:parent_id]
    target = args[:target]
    test_definition_id = args[:test_definition_id]

    
    if parent_id && parent_id.empty?
      []
    else
            
      runs =
      if target
        Run.where( :world_id => world_id, :target => target )
      else
        Run.where( :world_id => world_id )
      end
      
      run_ids = runs.collect { |r| r.id }
    
      if test_definition_id
        where_conditions = { :run_id => run_ids, :parent_id => parent_id, :test_definition_id => test_definition_id }
      else
        where_conditions = { :run_id => run_ids, :parent_id => parent_id }
      end

      results = Result.includes(:test_definition,
                      :run => [ :world ],
                      :children => [
                        :test_definition,
                        :run => [:world],
                        :children => [
                          :test_definition,
                          :run => [:world],
                          :children => [
                            :children,
                            :test_definition,
                            :run => [:world] ] ] ]
                      ).where( where_conditions )

      aggregate( results.flatten )
    end
  end

  # Class function for taking an array of result objects, and aggregating
  # them into an array of AggregateResult objects
  def self.aggregate( results )
    aggregates = results.reduce({}) do |m, r|
      key = r.test_definition.id.to_s + "---" + r.run.target.to_s
      if m.has_key?(key)
        m[key].add(r)
      else
        m[key] = AggregateResult.new( r.test_definition, r.run.world, [r] )
      end
      m
    end

    aggregates.values
  end

  # Returns an array of AggregateResult children
  def children
    if !@children
      child_result_set = @results.map { |r| r.children }
      @children = AggregateResult.aggregate(child_result_set.flatten)
    end
    @children
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
  def initialize( _test_definition, _world, _result )
    @test_definition = _test_definition
    @world = _world
    @results = _result
    @count = {}
  end


  def add(result)
    @best = nil
    @results.push(result)
  end

  #
  # Methods to make this look more like a Result object
  #
  def test_definition
    best.test_definition
  end

  def test_definition_id
    best.test_definition.id
  end

  def status
    if self.children.count == 0
      self.best.status
    else
      Result.summary_status(children)
    end
  end

  def target
    best.run.target if !best.run.nil?
  end

  # Counts the statuses of all the child elements
  def count (status)
    if !@count[status]
      @count[status] = self.children.collect { |c| c.status == status.to_s }.count(true)
    end
    @count[status]
  end

end