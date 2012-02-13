# External dependency.
crack = require 'crack'

# Response wraps around the XML data returned by the [Request](./request.html).
class Response
  # Creates a new response for given XML data and HTTP status code.
  constructor: (data, @code) ->
    @_doc = crack data

  # Queries for given node key and returns JavaScript object representations of
  # matching nodes.
  #
  # Optionally, passes nodes through a given function.
  find: (key, process) ->
    @_doc.find key, process

  # Returns a JavaScript object representation of the response.
  toJS: ->
    @_doc.toJS()

module.exports = Response
