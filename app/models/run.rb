class Run < ActiveRecord::Base
  belongs_to :world
  has_many :results

  def top_level_results
    results.select { |r| r.parent == nil }
  end

  def duration
    finished_at - started_at
  end
end
