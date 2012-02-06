_        = require 'underscore'
libxmljs = require 'libxmljs'

# The API response.
class Response
  # Creates a new response.
  constructor: (data, @code) ->
    @_doc = libxmljs.parseXmlString data.trim()

  find: (query) ->
    _.map @_doc.find("//xmlns:#{query}", @_ns()), (node) =>
      @_xmlToObject node

  _ns: ->
    @_doc.root().namespace().href()

  _xmlToObject: (node) ->
    obj = new Object

    _.each node.attrs(), (attr) ->
      obj[attr.name()] = attr.value()

    _.each node.childNodes(), (child) =>
      key = child.name()
      val = @_xmlToObject child

      if key is 'text'
        return val if _.isEmpty obj
        obj['__content__'] = val
      else if _.has obj, key
        if _.isArray obj[key]
          obj[key].push val
        else
          obj[key] = [obj[key], val]
      else
        obj[key] = val

    if _.isEmpty(obj) then node.text() else obj

module.exports = Response
