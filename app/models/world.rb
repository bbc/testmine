class World < ActiveRecord::Base
  before_create :generate_name

  has_many :runs

  scope :similar, ->(w) { where( project: w.project).where( component: w.component).where('id != ?', w.id ).order('id DESC').limit(100) }

  # Return the ids of recent similar worlds
  def similar
    World.similar(self)
  end

  def last_run
    runs.last
  end

  private
    def generate_name
      self.name = TokenPhrase.generate(:numbers => false).split('-').drop(2).join('-')
    end
end
