class Run < ActiveRecord::Base
  belongs_to :world
  has_many :results
end
