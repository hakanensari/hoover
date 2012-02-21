# External dependencies.
Bezos = require 'bezos'
http  = require 'http'

# Internal dependency.
Response = require './response'

# Request is a wrapper around the request to the Amazon Product Advertising
# API.
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
  #
  # Expects an access key, secret, associate tag, and, optionally, a country
  # locale. The latter will default to `us` if not given.
  #
  # While you may use the same credentials across multiple locales, note that
  # associate tags will not earn revenue outside their home locale.
  constructor: (options) ->
    @locale = options.locale           or 'us'
    @_bezos = new Bezos options.secret or throw 'Missing secret'
    @_key   = options.key              or throw 'Missing key'
    @_tag   = options.tag              or throw 'Missing associate tag'
    @reset()

  # Adds given parameters to the request.
  build: (params) ->
    for key, val of params
      val = val.join(',') if val.constructor is Array
      key = key[0].toUpperCase() + key.slice(1)
      @_params[key] = val

    this

  # Performs a request and takes a callback that will receive either a
  # [Response](./response.html) or an error.
  get: (callback) ->
    options =
      host: @host()
      path: @path()

    http.get options, (res) ->
      data = ''
      res
        .on 'data', (chunk) ->
          data += chunk
        .on 'end', ->
          callback null, new Response data, res.statusCode
        .on 'error', (e) ->
          callback e

    return

  # The request host.
  host: ->
    @HOSTS[@locale] or throw 'Bad locale'

  # The request path.
  path: ->
    @_bezos.sign 'GET'
               , @host()
               , '/onca/xml'
               , @_params

  # Resets request parameters.
  reset: ->
    @_params =
      AWSAccessKeyId: @_key
      AssociateTag:   @_tag
      Service:        'AWSECommerceService'
      Version:        @CURRENT_API_VERSION

    this

module.exports = Request
