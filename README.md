# Testmine

Testmine is test results tool for storing and analysing result data. Testmine takes result output for a test run, and stores it in a result bucket for historic analysis.

## Concepts

### Worlds

Testmine stores test results in buckets called worlds. A world is identified by the project, component, and version strings submitted along with the test results. So, for example, if you're testing a mobile application like iPlayer, you might submit against:

    project: 'iPlayer',
    component: 'android'
    version: <build_id>

This would mean every build has its results captured in a different bucket. Testmine uses the project and component names to allow you to compare worlds under test. So you could compare a new feature branch build, '1.1-new-feature' against the results for your last know release candidate: '1.0-rc' 

### Runs

Runs are the individual executions of your test suites. A run may comprise multiple test results for a particular world and target. A target represents the platform you are testing against. So for our Android app, it might be a particular device or OS build. You can view individual run results in testmine by clicking on a run id. While it can be useful to look at specific run results, the aggregated world views give an overview of your testing for a particular world.

### Aggregate Results

Testmine aggregates all the runs for a world into a single-page aggregated view of the results. Results are organised by target. It's important to note that the aggregated view takes the best results from across your test runs. So if you have two different runs, and a test passed in first run, but failed in the second run, the second result is discarded. This behaviour means that testmine filters out failed results where test behaviour is inconsistent.

### Comparison Results

Testmine can present a side-by-side view of aggregate results for two worlds. Testmine compares the results to provide a comparason status. They have the following meanings:
* **PASS**      Results passed consistently in line with the reference world
* **NEWPASS**   Tests that previously failed are now passing
* **REGRESS**   Tests that previously passed are now failing
* **FAIL**      Tests that failed previously are still failing
* **ERROR**     Tests failed to execute correctly
* **NOTRUN**    The tests have not been run

In addition, the comparison result will be faded if the results between the two worlds exactly match.

## Running testmine

Testmine is a straightforward Rails application. You can deploy a local copy easily by checking it out and running:


### Method # 1: Run directly on Host Machine

    bundle install --local --without development test
    bundle exec rake db:migrate
    bundle exec rails s

You should get a testmine instance on port 3002 with an sqlite database.

### Method # 2: Run it on Docker 

#### Prerequiste for Docker
1. Download and install docker https://docs.docker.com/docker-for-mac/install/
2. Install virtualbox on your machine.
```
$ brew cask install virtualbox
```
3. Create a default docker machine
```
$ docker-machine create default
```
4. Ensure your docker machine is running
```
$ docker-machine status
```
It should say "Running".

5. Get the ip address of your docker machine
```
$ docker-machine env default
...
export DOCKER_HOST="tcp://192.168.99.100:2376"
...
```
The ip address is 192.168.99.100 in this case.
6. Run the following command to configure your shell
```
eval $(docker-machine env default)
```

#### Run testmine on Docker

Run the following to startup a docker machine for testmine.

```
docker-compose build
docker-compose up
```

Visit the browser http://192.168.99.100:3002 to see the output.



## Submitting results

In order to submit your results to testmine, you will need to format your test results as Res IR
(see our [res](https://github.com/bbc/res) repo for more information). Res provides a number of formatters for sumbitting from popular test runner such as cucumber and rspec.

Alternatively you can hand-craft your own res output, and submit it against the endpoint: /api/v1/submit

## License

Testmine is available to everyone under the terms of the MIT open source licence.
Take a look at the LICENSE file in the code.

Copyright (c) 2016 BBC
