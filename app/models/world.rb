class World < ActiveRecord::Base
  before_create :generate_name
  
  has_many :runs

  def similar
    World.includes(:runs).where( :project => project, :component => component).limit(100).order('id DESC').select { |w| w.id != self.id }
  end

  private
    def generate_name
      self.name = "world_" + rand(100000).to_s
    end
end
