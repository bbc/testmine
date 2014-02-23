class TestDefinition < ActiveRecord::Base
  
  belongs_to :parent,   polymorphic: true
  has_many   :children, as: :parent
  
  def self.find_or_create(args)
    TestDefinition.where(
      name: args[:name],
      parent: args[:parent]
    ).first_or_create do |test|
      test.name = args[:name]
      test.node_type = args[:node_type]
      test.description = args[:description]
      test.file_name = args[:file_name]
      test.line = args[:line]
      test.parent = args[:parent]
    end
  end
  
end
