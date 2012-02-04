_        = require 'underscore'
crypto   = require 'crypto'
http     = require 'http'
Response = require './response'

# A wrapper around the request to the Amazon Product Advertising API.
class Request
  # Creates a new request for given locale.
  constructor: (options) ->
    @_key    = options.key    or throw 'Missing key'
    @_secret = options.secret or throw 'Missing secret'
    @_tag    = options.tag    or throw 'Missing associate tag'
    @_host   = {
      ca: 'ecs.amazonaws.ca',
      cn: 'webservices.amazon.cn',
      de: 'ecs.amazonaws.de',
      es: 'webservices.amazon.es',
      fr: 'ecs.amazonaws.fr',
      it: 'webservices.amazon.it',
      jp: 'ecs.amazonaws.jp',
      uk: 'ecs.amazonaws.co.uk',
      us: 'ecs.amazonaws.com'
    }[options.locale or 'us'] or throw 'Bad locale'
    @reset()

  # Merges the given key-value pairs into the request parameters.
  add: (properties) ->
    for key, val of properties
      val = val.join(',') if val.constructor == Array
      key = key[0].toUpperCase() + key.slice(1)
      @_params[key] = val

    @

  # Performs a request.
  get: (callback, errback = ->) ->
    options =
      host: @_host
      path: "/onca/xml?#{@_query()}"

    http.get options, (res) ->
      data = ''
      res.on 'data', (chunk) ->
        data += chunk
      .on 'end', ->
        callback new Response(data, res.statusCode)
    .on 'error', (e) ->
      errback e

  # Resets the request parameters.
  reset: ->
    @_params =
      AWSAccessKeyId : @_key
      AssociateTag   : @_tag
      Service        : 'AWSECommerceService'
      Timestamp      : new Date().toJSON()
      Version        : '2011-08-01'

    @

  _query: ->
    query = _
      .chain(@_params)
      .map (val, key) ->
        [key, val]
      .sortBy (tuple) ->
        tuple[0]
      .map (tuple) ->
        "#{tuple[0]}=#{encodeURIComponent(tuple[1])}"
      .value()
      .join('&')

    hmac = crypto.createHmac 'sha256', @_secret
    hmac.update [
      'GET',
      @_host,
      '/onca/xml',
      query
    ].join("\n")
    signature = hmac.digest 'base64'

    "#{query}&Signature=#{signature}"

module.exports = Request
