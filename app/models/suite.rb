class Suite < ActiveRecord::Base
  
  has_many :tests, as: :parent
  
  def self.find_or_create(args)
    Suite.where(
      project: args[:project],
      name: args[:name] 
    ).first_or_create do |suite|
      suite.project = args[:project]
      suite.name = args[:name]
      suite.runner = args[:runner]
      suite.description = args[:description]
      suite.documentation = args[:documentation]
      suite.url = args[:url]
      suite.repo = args[:repo]
    end
  end

end
