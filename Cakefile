fs     = require 'fs'
{exec} = require 'child_process'

run = (cmd) ->
  exec cmd, (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'build', 'Build project', ->
  run 'rm -rf lib/* && coffee --compile --output lib/ src/'

task 'document', 'generate docs', ->
  run 'docco src/**/*.coffee'

task 'publish', 'Publish docs to GitHub', ->
  exec 'git rm --ignore-unmatch doc && git status', (err, stdout) ->
    if stdout.match /nothing to commit/
      publish = (msg, cmd) ->
        cmds = [
          'rm -rf docs',
          'node_modules/docco/bin/docco src/**/*.coffee',
          cmd,
          'ls -1 | grep -v docs | xargs rm -rf',
          'mv docs/* .',
          'rm -rf docs',
          'git add .',
          "git commit -m '#{msg}'",
          'git push origin gh-pages',
          'git checkout master',
          'rm -rf docs',
          'npm install'
        ].join(' && ')
        exec cmds

      exec 'git branch', (err, stdout, stderr) ->
        throw err if err
        if stdout.match /gh-pages/
          publish 'Update docs',
                  'git checkout gh-pages'
        else
          publish 'Create docs',
                  'git symbolic-ref HEAD refs/heads/gh-pages; rm .git/index'
    else
      console.error 'Index is dirty!'

task 'release', 'Release project to npm', ->
  invoke 'build'
  process.nextTick ->
    run 'npm publish'

task 'test', 'Run specs', ->
  run 'npm test'
