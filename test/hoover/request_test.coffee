should   = require 'should'
Request  = require '../../src/hoover/request'
Response = require '../../src/hoover/response'

describe 'Request', ->
  describe 'when created', ->
    it 'requires a key', ->
      (
        ->
          new Request
            secret: 'foo'
            tag:    'bar'
      ).should.throw

    it 'requires a secret', ->
      (
        ->
          new Request
            key: 'foo'
            tag: 'bar'
      ).should.throw

    it 'requires a tag', ->
      (
        ->
          new Request
            key:    'foo'
            secret: 'bar'
      ).should.throw

    it 'defaults to the US locale', ->
      new Request
        key:    'foo'
        secret: 'bar'
        tag:    'baz'
      .locale.should.eql 'us'

    it 'populates default parameters', ->
      req = new Request
        key:    'foo'
        secret: 'bar'
        tag:    'baz'
      for key in ['AWSAccessKeyId',
                  'AssociateTag',
                  'Service',
                  'Timestamp',
                  'Version']
        should.exist req._params[key], "expected #{key} to exist"

  describe '#add', ->
    beforeEach ->
      @req =
        new Request
          key:    'foo'
          secret: 'bar'
          tag:    'baz'
        .add
          foo: 1
          Bar: [1, 2]

    it 'capitalizes keys', ->
      should.exist @req._params['Foo']

    it 'casts array values to string', ->
      @req._params['Bar'].should.equal '1,2'

  describe '#get', ->
    it 'returns a response', (done) ->
      new Request
        key:    'foo'
        secret: 'bar'
        tag:    'baz'
      .get (err, res) ->
        throw err if err
        res.should.be.an.instanceof Response
        done()

  describe '#host', ->
    it 'requires a valid locale', ->
      (
        ->
          new Request
            key:    'foo'
            secret: 'bar'
            tag:    'baz'
            locale: 'bad'
          .host()
      ).should.throw


  describe '#path', ->
    beforeEach ->
      @path = new Request
        key:    'foo'
        secret: 'bar'
        tag:    'baz'
        locale: 'uk'
      .add(a: 'foo,bar')
      .path()

    it 'sorts the parameters', ->
      @path.should.match /\?A=/

    it 'canonicalizes the parameters', ->
      @path.should.match /\w+=\w+&/

    it 'URL-encodes', ->
      @path.should.match /foo%2Cbar/

    it 'signs', ->
      @path.should.match /&Signature=.*/

  describe '#reset', ->
    it 'deletes added keys', ->
      req = new Request
        key:    'foo'
        secret: 'bar'
        tag:    'baz'
        locale: 'uk'
      .add
        foo: 1
      .reset()

      should.not.exist req._params['Foo']
