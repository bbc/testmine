class World < ActiveRecord::Base
  before_create :generate_name
  
  has_many :runs

  # Return the ids of recent similar worlds
  def similar(limit = 100)
    World.where( :project => project, :component => component).limit(limit).order('id DESC').ids.select { |id| id != self.id }
  end

  private
    def generate_name
      self.name = "world_" + rand(100000).to_s
    end
end
