vows   = require 'vows'
assert = require 'assert'

Request  = require '../../src/hoover/request'
Response = require '../../src/hoover/response'

vows
  .describe('A request')
  .addBatch
    'with no key':
      topic: ->
        new Request
          secret: 'foo'
          tag:    'bar'

      'throws an error': (req) ->
        assert.throws req

    'with no secret':
      topic: ->
        new Request
          key: 'foo'
          tag: 'bar'

      'throws an error': (req) ->
        assert.throws req

    'with no tag':
      topic: ->
        new Request
          key:    'foo'
          secret: 'bar'

      'throws an error': (req) ->
        assert.throws req

    'with no locale':
      topic: ->
        new Request
          key:    'foo'
          secret: 'bar'
          tag:    'baz'

      'defaults to the US': (req) ->
        assert.equal req.locale, 'us'

    'with a bad locale':
      topic: ->
        new Request
          key:    'foo'
          secret: 'bar'
          tag:    'baz'
          locale: 'bad'

      'and returning the host':
        topic: (req) ->
          req.host()

        'throws an error': (host) ->
          assert.throws host

    'with a good locale':
      topic: ->
        new Request
          key:    'foo'
          secret: 'bar'
          tag:    'baz'
          locale: 'uk'

      'uses that locale': (req) ->
        assert.equal req.locale, 'uk'

    'with proper credentials':
      topic: ->
        new Request
          key:    'foo'
          secret: 'bar'
          tag:    'baz'

      'populates the default parameters': (req) ->
        for key in ['AWSAccessKeyId',
                    'AssociateTag',
                    'Service',
                    'Timestamp',
                    'Version']
          assert.isString req._params[key]

    'when given new parameters':
      topic: ->
        new Request
          key:    'foo'
          secret: 'bar'
          tag:    'baz'
        .add
          foo: 1
          Bar: [1, 2]

      'capitalizes keys': (req) ->
        assert.equal req._params['Foo'], 1

      'casts array values to strings': (req) ->
        assert.equal req._params['Bar'], '1,2'

    'when run':
      topic: ->
        new Request
          key:    'foo'
          secret: 'bar'
          tag:    'baz'
        .get @callback

      'returns a response': (err, res) =>
        assert.equal err, undefined
        assert.instanceOf res, Response

    'when reset':
      topic: ->
        new Request
          key:    'foo'
          secret: 'bar'
          tag:    'baz'
          locale: 'uk'
          foo: 1
        .reset()

      'deletes non-default keys': (req) ->
        assert.isUndefined req._params['Foo']

    'when building the query':
      topic: ->
        new Request
          key:    'foo'
          secret: 'bar'
          tag:    'baz'
          locale: 'uk'
          foo: 1
        .add(a: 'foo,bar')
        ._query()

      'sorts the parameters': (query) ->
        assert.match query, /^A=/

      'canonicalizes the parameters': (query) ->
        assert.match query, /\w+=\w+&/

      'URL-encodes': (query) ->
        assert.match query, /foo%2Cbar/

      'signs': (query) ->
        assert.match query, /&Signature=.*/

  .export(module)
