class TestDefinition < ActiveRecord::Base
  
  belongs_to :suite
  belongs_to :parent,   :foreign_key => "parent_id", :class_name => 'TestDefinition'
  has_many   :children, :foreign_key => "parent_id", :class_name => 'TestDefinition', :dependent => :destroy
  has_many   :results
  acts_as_taggable
  default_scope { includes( :parent, :tags) }
#  default_scope { includes(:children) } #TODO Test impact of this default scope


  def self.find_or_create(args)
    TestDefinition.where(
      name: args[:name],
      suite_id: args[:suite_id],
      file: args[:file],
      parent_id: args[:parent_id]
    ).first_or_create do |test|
      test.name = args[:name]
      test.node_type = args[:node_type]
      test.description = args[:description]
      test.file = args[:file]
      test.line = args[:line]
      test.parent_id = args[:parent_id]
      test.tag_list = args[:tags]
    end
  end
  
  def all_tags
    if ! @all_tags
      all = self.tags.collect { |t| t.name }
      if self.parent
        all += self.parent.all_tags
      end
      all.uniq
      @all_tags = all.uniq
    else
    end
    @all_tags
  end
  
  def add_test_definition(args)
    args[:suite_id] = self.suite_id
    args[:parent_id] = self.id
    args[:file] = self.file if !args[:file]
    TestDefinition.find_or_create(args)
  end
  
  def file_name( modifier = :short )
    file_name = file
    if modifier == :short
      file =~ /.*features\/(.*.feature)/
      file_name = $1 if $1
    end
    file_name
  end
end
