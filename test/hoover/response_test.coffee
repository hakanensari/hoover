fs       = require 'fs'
should   = require 'should'
Response = require '../../src/hoover/response'

describe 'Response', ->
  beforeEach ->
    data = fs.readFileSync("#{__dirname}/../fixtures/response", 'UTF-8')
    @res = new Response data, 200

  describe '#toJS', ->
    it 'returns an object representation of the response', ->
      @res.toJS().should.be.an.instanceof Object

  describe '#find', ->
    it 'returns matches', ->
      @res.find('Item')
      @res.find('Item').should.not.be.empty

    it 'returns nested nodes with no siblings', ->
      @res.find('Item')[0]['ASIN'].should.be.a 'string'

    it 'parses nodes with siblings', ->
      @res.find('Item')[0]['ItemLinks']['ItemLink'].should.not.be.empty

    it 'parses nodes with attributes', ->
      creator = @res.find('Item')[0]['ItemAttributes']['Creator']
      creator['Role'].should.be.a 'string'
      creator['__content'].should.be.a 'string'

    describe 'when no matches are found', ->
      it 'returns an empty array', ->
        @res.find('foo').should.eql []

    describe 'when given a function', ->
      it 'passes matches through it', ->
        asins = @res.find 'Item', (item) -> item['ASIN']
        for asin in asins
          asin.should.match /^\w{10}$/
