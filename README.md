# Testmite

Testmite is test results tool for storing and analysing result data. Testmite takes result output for a test run, and stores it in a result bucket for historic analysis.

## Concepts

### Worlds

Testmite stores test results in buckets called worlds. A world is identified by the project, component, and version strings submitted along with the test results. So, for example, if you're testing a mobile application, you might submit

## Running testmite

Testmite is a straightforward Rails application. You can deploy a local copy easily by checking it out and running:

    bundle install --local --without development test
    bundle exec rake db:migrate
    bundle exec rails s

You should get a testmite instance on port 3000 with an sqlite database.

## Submitting results

In order to submit your results to testmite, you will need to format your test results as PostResult IR
(see our [post_result](/bbc-test/post_result) repo for more information). PostResult provides a cucumber formatter that does that for you. If you need to write your own result reporter, the submission endpoint is: /api/v1/submit
