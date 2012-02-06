Request = require '../../src/hoover/request'

describe 'Request', ->
  beforeEach ->
    @req = new Request
      key:    process.env.AMAZON_KEY
      secret: process.env.AMAZON_SECRET
      tag:    process.env.AMAZON_TAG

  describe 'constructor', ->
    it 'requires a key', ->
      expect ->
        new Request
          secret: 'foo'
          tag:    'bar'
      .toThrow 'Missing key'

    it 'requires a secret', ->
      expect ->
        new Request
          key: 'foo'
          tag: 'bar'
      .toThrow 'Missing secret'

    it 'requires an associate tag', ->
      expect ->
        new Request
          key:    'foo'
          secret: 'bar'
      .toThrow 'Missing associate tag'

    it 'defaults locale to the US', ->
      expect(@req.locale).toBe 'us'

    it 'sets up the parameters with default values', ->
      expect(@req._params.Timestamp).toBeDefined()

  describe '#add', ->
    it 'adds new parameters to the existing ones', ->
      expect(@req.add(foo: 'bar')._params.Foo).toBe('bar')

    it 'casts values that are arrays to strings', ->
      expect(@req.add(foo: [1, 2])._params.Foo).toBe('1,2')

  describe '#get', ->
    it 'returns a response', ->
      @req.get (@res) =>

      waitsFor ->
        @res?
      , 'Response timed out', 1000

      runs ->
        expect(@res.constructor).toMatch /Response/

  describe '#host', ->
    it 'requires a valid locale', ->
      @req.locale = 'invalid'
      expect =>
        @req.host()
      .toThrow 'Bad locale'

  describe '#reset', ->
    it 'resets the parameters to default values', ->
      expect(@req.add(foo: 1).reset.foo).toBeUndefined()

  describe '#_query', ->
    it 'sorts the parameters', ->
      expect(@req.add(a: 0)._query()).toMatch /^A=0/

    it 'canonicalizes the parameters', ->
      expect(@req._query()).toMatch /\w+=\w+&/

    it 'URL-encodes values', ->
      expect(@req.add(foo: 'bar,baz')._query()).toMatch /bar%2Cbaz/

    it 'signs the query', ->
      expect(@req._query()).toMatch /&Signature=.*/
