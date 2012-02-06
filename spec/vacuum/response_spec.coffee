fs       = require 'fs'
libxmljs = require 'libxmljs'
Response = require '../../src/hoover/response'

describe 'Response', ->
  beforeEach ->
    data = fs.readFileSync("#{__dirname}/../fixtures/response", 'utf8')
    @res = new Response data, 200

  describe '#find', ->
    beforeEach ->
      @items = @res.find('Item')

    it 'returns matches to a given query', ->
      expect(@items.length).toBeGreaterThan 0

    it 'returns an empty array if there are no matches', ->
      expect(@res.find('foo-bar-baz').length).toBe 0

    it 'parses nodes with no siblings', ->
      expect(@items[0]['ASIN']).toBeDefined()

    it 'parses nodes with siblings', ->
      itemLinks = @items[0]['ItemLinks']['ItemLink']
      expect(itemLinks.length).toBeGreaterThan 0

    it 'parses nodes with attributes', ->
      creator = @items[0]['ItemAttributes']['Creator']
      expect(creator['Role']).toBeDefined()
      expect(creator['__content']).toBeDefined()

  describe '#toObject', ->
    it 'returns entire response as an object', ->
      expect(@res.toObject().constructor).toBe Object
