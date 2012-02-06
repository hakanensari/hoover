crypto   = require 'crypto'
http     = require 'http'
Response = require './response'

# A wrapper around the request to the Amazon Product Advertising API.
class Request
  # The latest Amazon API version.
  CURRENT_API_VERSION: '2011-08-01'

  # A list of Amazon endpoints.
  HOSTS: {
    ca: 'ecs.amazonaws.ca'
    cn: 'webservices.amazon.cn'
    de: 'ecs.amazonaws.de'
    es: 'webservices.amazon.es'
    fr: 'ecs.amazonaws.fr'
    it: 'webservices.amazon.it'
    jp: 'ecs.amazonaws.jp'
    uk: 'ecs.amazonaws.co.uk'
    us: 'ecs.amazonaws.com'
  }

  # Creates a new request for given credentials.
  constructor: (options) ->
    @locale  = options.locale or 'us'
    @_key    = options.key    or throw 'Missing key'
    @_secret = options.secret or throw 'Missing secret'
    @_tag    = options.tag    or throw 'Missing associate tag'
    @reset()

  # Adds given parameters to the request.
  add: (params) ->
    for key, val of params
      val = val.join(',') if val.constructor is Array
      key = key[0].toUpperCase() + key.slice(1)
      @_params[key] = val

    this

  # Performs request.
  get: (callback, errback = ->) ->
    options =
      host: @host()
      path: "/onca/xml?#{@_query()}"

    http.get options, (res) ->
      data = ''
      res
        .on 'data', (chunk) ->
          data += chunk
        .on 'end', ->
          callback new Response data, res.statusCode
        .on 'error', (e) ->
          errback e

  # The Amazon endpoint.
  host: ->
    @HOSTS[@locale] or throw 'Bad locale'

  # Resets the parameters of the request.
  reset: ->
    @_params =
      AWSAccessKeyId: @_key
      AssociateTag:   @_tag
      Service:        'AWSECommerceService'
      Timestamp:      new Date().toISOString()
      Version:        @CURRENT_API_VERSION

    this

  _query: ->
    # Sort parameters and generate a query.
    query =
      ("#{k}=#{encodeURIComponent v}" for k, v of @_params)
      .sort()
      .join('&')

    # Sign.
    hmac = crypto.createHmac 'sha256', @_secret
    hmac.update [
      'GET',
      @host(),
      '/onca/xml',
      query
    ].join("\n")
    signature = hmac.digest 'base64'

    "#{query}&Signature=#{encodeURIComponent(signature)}"

module.exports = Request
