class ReliabilityController < ApplicationController
 
  def show
    suite_id = params[:suite]
    @suite_name = get_suite_name(suite_id)
    @fail_last_day = fail_last_day(suite_id)
    @fail_last_week = fail_last_week(suite_id)
    @fail_last_month = fail_last_month(suite_id)
    @pass_last_day = pass_last_day(suite_id)
    @pass_last_week = pass_last_week(suite_id)
    @pass_last_month = pass_last_month(suite_id)
    @reliability_last_day = get_reliability(@fail_last_day,@pass_last_day)
    @reliability_last_week = get_reliability(@fail_last_week,@pass_last_week)
    @reliability_last_month = get_reliability(@fail_last_month,@pass_last_month)
  end

  def get_suite_name(suite_id)
    suite_name = Suite.find_by_sql("SELECT suites.name from suites where suites.id =  " + suite_id.to_s)
    suite_name[0].name || ""
  end

  def get_reliability(fails,passes)
    fails = fails.to_f
    passes = passes.to_f

    100.0 - (fails/passes * 100/1) 
  end

  def fail_last_day(suite_id)
    fail_count(suite_id,2)
  end

  def fail_last_week(suite_id)
    fail_count(suite_id,7)
  end

  def fail_last_month(suite_id)
    fail_count(suite_id,30)
  end

  def pass_last_day(suite_id)
    pass_count(suite_id,2)
  end

  def pass_last_week(suite_id)
    pass_count(suite_id,7)
  end

  def pass_last_month(suite_id)
    pass_count(suite_id,30)
  end

  def fail_count(suite_id, numberofdays)
    TestDefinition.find_by_sql("SELECT test_definitions.id,test_definitions.name,results.status,runs.id,runs.finished_at from results, test_definitions, runs where results.test_definition_id = test_definitions.id and results.run_id = runs.id and test_definitions.suite_id = " + suite_id.to_s + " and results.status = 'fail' AND runs.finished_at >= NOW() - INTERVAL "+numberofdays.to_s+" DAY").count
  end

  def pass_count(suite_id, numberofdays)
    TestDefinition.find_by_sql("SELECT test_definitions.id,test_definitions.name,results.status,runs.id,runs.finished_at from results, test_definitions, runs where results.test_definition_id = test_definitions.id and results.run_id = runs.id and test_definitions.suite_id = " + suite_id.to_s + " and results.status = 'pass' AND runs.finished_at >= NOW() - INTERVAL " + numberofdays.to_s + " DAY").count
  end

end
