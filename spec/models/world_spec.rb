require 'spec_helper'

describe World do
  
  describe World::SingleComponent do
    
    describe "#find_or_create" do
      
      it "creates a new world with a world id" do
        world = World::SingleComponent.find_or_create(
          :component => "TestMite",
          :project   => "Hive",
          :version   => "1.2.3" )
        
        world.should be_a World::SingleComponent
        world.id.should be_a Fixnum
        world.component.should be_a String
        world.project.should be_a String
        world.version.should be_a String
        world.name.should be_a String
      end
    
      it "creates and retrieves a world just created" do
        args = {
          :project   => "Hive",
          :component => "TestMite",
          :version   => "1.2.3" }
        
        world1 = World::SingleComponent.find_or_create( args )
        world2 = World::SingleComponent.find_or_create( args )
        
        world1.id.should == world2.id
      end
    
      it "retrieves two runs for a world" do
        world = World::SingleComponent.find_or_create(
          :component => "TestMite",
          :project   => "Hive",
          :version   => "1.2.3" )
        
        r1 = Run.create( world: world, target: 'x86_64' )
        r2 = Run.create( world: world, target: 'x86_64' )
        
        world.runs.count.should == 2
        
      end
    
    end
    
  end

end
