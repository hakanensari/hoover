{exec} = require 'child_process'

run = (cmd) ->
  exec cmd, (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

publish = (msg, cmd) ->
  exec 'git status', (err, stdout) ->
    if stdout.match /nothing to commit/
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
    else
      console.error 'Index is dirty!'

task 'build', 'Build project', ->
  run 'rm -rf lib/* && coffee --compile --output lib/ src/'

task 'document', 'generate docs', ->
  run 'docco src/**/*.coffee'

task 'pages:init', 'Initialize GitHub Pages', ->
  publish 'Create docs',
          'git symbolic-ref HEAD refs/heads/gh-pages; rm .git/index'

task 'pages:update', 'Update GitHub Pages', ->
  publish 'Update docs',
          'git checkout gh-pages'

task 'publish', 'Publish project', ->
  run 'npm publish'

task 'test', 'Run specs', ->
  run 'vows'

