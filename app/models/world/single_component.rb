class World::SingleComponent < World
  
  def self.find_or_create( args )
    component = args[:component] || raise( ArgumentError, "Need to provide component name (e.g. 'tal')")
    
    version = args[:version] || raise( ArgumentError, "Need to provide a version string (e.g. '1.2.3')")
    
    project = args[:project] || raise( ArgumentError, "Need to provide a project string (e.g. 'iplayer')" )
    
    World::SingleComponent.where( :component => component,
                                  :project   => project,
                                  :version   => version ).first_or_create
  end
  
end
