# External dependency.
libxmljs = require 'libxmljs'

# Response wraps around the XML data returned by the [Request](./request.html).
class Response
  # Creates a new response for given XML data and HTTP status code.
  constructor: (data, @code) ->
    @_root = libxmljs.parseXmlString(data.trim()).root()
    @_ns   = @_root.namespace().href()

  # Queries response for given node key and returns an object representation of
  # matching nodes.
  #
  # Optionally takes a function to pass through returned nodes.
  find: (key, passThrough) ->
    for node in @_root.find "//xmlns:#{key}", @_ns
      if passThrough
        passThrough @_parse node
      else
        @_parse node

  # Returns an object representation of the response.
  toObject: ->
    @_parse @_root

  # This is an internal method used to cast the XML to a JavaScript object.
  _parse: (node) ->
    obj = {}

    for attr in node.attrs()
      obj[attr.name()] = attr.value()

    for child in node.childNodes()
      key = child.name()
      if key is 'text'
        val = child.text()
        if Object.keys(obj).length is 0
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
