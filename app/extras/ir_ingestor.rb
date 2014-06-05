require 'json'
class IrIngestor


  def self.parse_ir( json )

    ir = JSON.parse(json)

    type     = ir["type"] || "ruby cucumber"
    started  = ir["started"]
    finished = ir["finished"]
    target   = ir["target"]
    project  = ir["project"] || ir["world"]["project"]
    component= ir["component"] || ir["world"]["component"]
    version  = ir["version"] || ir["world"]["version"]
    results  = ir["results"] || ir["tests"]
    suite    = ir["suite"]
    hive_job_id = ir["hive_job_id"] || ir["hive_job"]

    #
    # 1) Process the world under test
    #

    world = process_world( project, component, version) or raise "Couldn't derive a world"


    #
    # 2) Process the run information
    # (Need the world to create a run)
    #

    run = Run.create( :started_at  => started,
                      :finished_at => finished,
                      :target      => target,
                      :hive_job_id => hive_job_id,
                      :world_id    => world.id ) or raise "Couldn't create a new run"
    #
    # 3) Process the suite
    #
    suite = Suite.find_or_create(
      project:       project,
      name:          suite,
      runner:        type,
    )

    #
    # 4) Process the test results
    # (Need the run to associate with results)
    #

    results = process_results( run, suite, results, suite ) or raise "Couldn't process results"

    run.status = Result.summary_status( results )
    run.save
    run
  end


  def self.process_world( project, component, version )
     World::SingleComponent.find_or_create(
        :component => component,
        :project   => project,
        :version   => version )
  end

  # Recursively process results structure
  def self.process_results(run, suite, results_array, parent_definiton, parent_result = nil)

    results = []
    if results_array.respond_to?(:each)
      results_array.each do |r|
        file        = r["file"]
        line        = r["line"]
        type        = r["type"]
        name        = r["name"]
        description = r["description"]
        children    = r["children"]
        status      = r["status"]
        started     = r["started"]
        finished    = r["finished"]


        test_definition = parent_definiton.add_test_definition(
          name: name,
          node_type: type,
          file: file,
          line: line,
          description: description
        )

        parent_id = parent_result.id if parent_result
        result = Result.create(
          :test_definition_id => test_definition.id,
          :status => status,
          :parent_id => parent_id,
          :run_id => run.id,
          :started_at => started,
          :finished_at => finished
        )

        if children
          child_results = process_results(run, suite, children, test_definition, result)

          if !status
            result.status =  Result.summary_status( child_results )
            result.save
          end
        end
        results.push result
      end
    else
      puts results_array.inspect
    end

    results
  end

end
