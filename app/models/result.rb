class Result < ActiveRecord::Base
  belongs_to :test_definition
  belongs_to :run
  belongs_to :parent, :foreign_key => "parent_id", :class_name => 'Result'
  has_many   :children, :foreign_key => "parent_id", :class_name => 'Result', :dependent => :destroy
  alias_attribute :test, :test_definition

  # Count the status results of children
  #   result.count(:pass)
  def count (status)
    # Note the use of collect and count here, rather than just a simple
    # count. This is because children is some kind of ActiveRecord array
    # and count doesn't work quite as expected on it
    self.children.collect { |c| c.status == status.to_s }.count(true)
  end

  # returns an integer that represents the test result status
  # Useful for sorting results based on status
  def status_score
    { "pass"    => 5,
      "fail"    => 4,
      "error"   => 3,
      "timeout" => 2,
      "notrun"  => 1 }[status]
  end

  # Given a collection of result objects, return a summary of the
  # the result
  # i.e. pass, pass, fail => fail
  #      pass, error, notrun => notrun
  def self.summary_status(results)
    statuses = results.collect { |r| r.status }

    resulting_status = "error"
    resulting_status = "pass"   if statuses.count("pass") > 0
    resulting_status = "notrun" if statuses.count("notrun") > 0
    resulting_status = "fail"   if statuses.count("fail") > 0

    resulting_status
  end

  def world
    run.world
  end
end
