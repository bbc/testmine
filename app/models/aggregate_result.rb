class AggregateResult
  attr_accessor :results

  # Returns an array of AggregateResult objects
  def self.find( args )

    world_id = args[:world_id]
    parent_id = args[:parent_id]

    runs = Run.where( :world_id => world_id )
    results = runs.collect { |r| Result.where( :run_id => r.id, :parent_id => parent_id ) }

    aggregate( results.flatten )
  end

  # Class function for taking an array of result objects, and aggregating
  # them into an array of AggregateResult objects
  def self.aggregate( results )
    aggregates = results.reduce({}) do |m, r|
      key = r.test_definition.id.to_s + "---" + r.run.target.to_s
      if m.has_key?(key)
        m[key].add(r)
      else
        m[key] = AggregateResult.new( r )
      end
      m
    end
    aggregates.values
  end

  # Returns an array of AggregateResult children
  def children
    child_result_set = @results.map { |r| r.children }
    AggregateResult.aggregate(child_result_set.flatten)
  end

  def best
    if !@best
      if @results.empty?
        @results = [ Result.new(:status => :notrun) ]
      end

      sorted_results = @results.sort { |a, b| a.status_score <=> b.status_score }

      @best = sorted_results.last
    end
    @best
  end

  #
  # Given a Result, or an array of Results, creates an AggregateResult
  # object.
  #
  def initialize( *results )
    @results = results
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

  def world_id
    best.run.world_id if !best.run.nil?
  end

  def status
    best.status
  end

  def target
    best.run.target if !best.run.nil?
  end

  def count (status)
    best.count(status)
  end

end