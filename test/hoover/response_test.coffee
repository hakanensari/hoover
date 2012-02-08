vows     = require 'vows'
assert   = require 'assert'
fs       = require 'fs'
Response = require '../../src/hoover/response'

vows
  .describe('A response')
  .addBatch
    'when created':
      topic: ->
        data = fs.readFileSync("#{__dirname}/../fixtures/response", 'UTF-8')
        new Response data, 200

      'and cast to an object':
        topic: (res) ->
          res.toObject()

        'returns an object representation of itself': (obj) ->
          assert.isObject obj

      'and queried for an existing node':
        topic: (res) ->
          res.find 'Item'

        'returns matches': (items) ->
          assert.isTrue items.length > 0

        'returns nested nodes with no siblings': (items) ->
          assert.isString items[0]['ASIN']

        'parses nodes with siblings': (items) ->
          assert.isNotZero items[0]['ItemLinks']['ItemLink'].length

        'parses nodes with attributes': (items) ->
          creator = items[0]['ItemAttributes']['Creator']
          assert.isString creator['Role']
          assert.isString creator['__content']

      'and queried for a non-existing node':
        topic: (res) ->
          res.find 'foo'

        'returns an empty array': (result) ->
          assert.isEmpty result
          assert.isArray result

      'and queried with a function':
        topic: (res) ->
          res.find 'Item', (item) -> item['ASIN']

        'passes matches through that function': (asins) ->
          for asin in asins
            assert.match asin, /^\w{10}$/

  .export(module)
