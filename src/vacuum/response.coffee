libxmljs = require 'libxmljs'

# The API response.
class Response
  # Creates a new response for given XML data and HTTP status code.
  constructor: (data, @code) ->
    @_root = libxmljs.parseXmlString(data.trim()).root()
    @_ns   = @_root.namespace().href()

  # Queries response for given attribute key and returns object representation
  # of matching nodes.
  find: (key) ->
    for node in @_root.find "//xmlns:#{key}", @_ns
      @_parse node

  # Returns an object representation of the entire response.
  toObject: ->
    @_parse @_root

  _parse: (node) ->
    obj = {}

    for attr in node.attrs()
      obj[attr.name()] = attr.value()

    for child in node.childNodes()
      key = child.name()
      if key is 'text'
        val = child.text()
        if Object.keys(obj).length == 0
          obj = val
        else
          obj['__content'] = val
      else
        val = @_parse child
        if obj[key]
          obj[key] = [obj[key]] unless obj[key].constructor is Array
          obj[key].push val
        else
          obj[key] = val

    obj

module.exports = Response
