{exec} = require 'child_process'

task 'build', 'Build project', ->
  exec 'rm -rf lib/* && coffee --compile --output lib/ src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'publish', 'Publish project', ->
  invoke 'build'
  exec 'npm publish', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'spec', 'Run specs', ->
  exec 'jasmine-node --coffee spec/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
