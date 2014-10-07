class World < ActiveRecord::Base
  before_create :generate_name
  
  has_many :runs
  
  scope :similar, ->(w) { where( project: w.project).where( component: w.component).where('id != ?', w.id ).order('id DESC').limit(100) }

  # Return the ids of recent similar worlds
  def similar
    World.similar(self)
  end

  private
    def generate_name
      self.name = "world_" + rand(100000).to_s
    end
end
