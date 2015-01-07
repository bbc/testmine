== Testmite

Testmite is our test results analytics platform. You can get up and running very easily by running:
    bundle install --local --without development test
    bundle exec rake db:migrate
    bundle exec rails s
You should get a testmite instance on port 3000 with an sqlite database.

=== Submitting results

In order to submit your results to testmite, you will need to format your test results as PostResult IR
(see our PostResult repo for more information) and post the json to this endpoint: /api/v1/submit
