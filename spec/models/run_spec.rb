require 'spec_helper'

describe Run do
  
  before(:all) do
    @world = World::SingleComponent.find_or_create(
          :component => "TestMite",
          :project   => "Titan",
          :version   => "1.2.3" )
  end

  describe "create" do
    it "creates and retrieves a run" do
      run = Run.create( world: @world, target: 'x86_64' )
      
      run.should be_a Run
      run.id.should be_a Fixnum
      run.target.should == 'x86_64'
      run.world.should be_a World::SingleComponent
    end
  end
  
end
