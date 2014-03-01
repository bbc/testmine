class TestDefinition < ActiveRecord::Base
  
  belongs_to :suite
  belongs_to :parent,   :foreign_key => "parent_id", :class_name => 'TestDefinition'
  has_many   :children, :foreign_key => "parent_id", :class_name => 'TestDefinition', :dependent => :destroy

  def self.find_or_create(args)
    TestDefinition.where(
      name: args[:name],
      suite_id: args[:suite_id],
      parent_id: args[:parent_id]
    ).first_or_create do |test|
      test.name = args[:name]
      test.node_type = args[:node_type]
      test.description = args[:description]
      test.file_name = args[:file_name]
      test.line = args[:line]
      test.parent_id = args[:parent_id]
    end
  end

  def find_or_add_test_definition(args)
    args[:suite_id] = self.suite_id
    args[:parent_id] = self.id
    TestDefinition.find_or_create(args)
  end
  
end
