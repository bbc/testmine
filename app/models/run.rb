class Run < ActiveRecord::Base
  belongs_to :world
  has_many :results
  
  has_many :top_level_results, -> { where(:parent_id => nil) }, class_name: 'Result'

  def duration
    if finished_at && started_at
      (finished_at - started_at).to_i
    else
      0
    end
  end
end
