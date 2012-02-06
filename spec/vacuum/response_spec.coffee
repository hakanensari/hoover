fs       = require 'fs'
libxmljs = require 'libxmljs'
Response = require '../../lib/vacuum/response'

describe 'Response', ->
  beforeEach ->
    data = fs.readFileSync("#{__dirname}/../fixtures/response", 'utf8')
    @res = new Response data, 200

  describe '#find', ->
    it 'returns an array of matches', ->
      expect(@res.find('Item').constructor).toBe Array
      expect(@res.find('Item')[0]['ASIN'].constructor).toBe String

  describe '#_xmlToObject', ->
    beforeEach ->
      data = '<?xml version="1.0" ?>' +
             '<Item>' +
             '<Title>A Title</Title>' +
             '<Author>An Author</Author>' +
             '<Author>Another Author</Author>' +
             '<Creator Role="Translator">A Translator</Creator>' +
             '</Item>'
      doc = libxmljs.parseXmlString(data)
      @obj = @res._xmlToObject doc.root()

    it 'returns an object', ->
      expect(@obj.constructor).toBe Object

    it 'handles children with no siblings', ->
      expect(@obj['Title']).toBe 'A Title'

    it 'handles children with siblings', ->
      expect(@obj['Author'].constructor).toBe Array

    it 'handles attributes', ->
      expect(@obj['Creator']['Role']).toBe 'Translator'
      expect(@obj['Creator']['__content__']).toBe 'A Translator'
