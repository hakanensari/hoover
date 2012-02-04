_        = require 'underscore'
http     = require 'http'
Response = require './response'

class Request
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

  add: (properties) ->
    for key, value of properties
      value = value.join(',') if value.constructor == Array
      key = key[0].toUpperCase() + key.slice(1)

      @params[key] = value

    @

  get: (callback) ->
    options =
      host: @_host
      path: "/onca/xml?#{@_query()}"

    http.get options, (res) ->
      data = ''
      res.on 'data', (chunk) ->
        data += chunk
      .on 'end', ->
        callback new Response(data, res.statusCode)
    .on 'error', (error) ->

  reset: ->
    @params =
      AWSAccessKeyId : @_key
      AssociateTag   : @_tag
      Service        : 'AWSECommerceService'
      Timestamp      : new Date().toJSON()
      Version        : '2011-08-01'

    @

  _query: ->
    _
      .chain(@params)
      .map (value, key) ->
        [key, value]
      .sortBy (tuple) ->
        tuple[0]
      .map (tuple) ->
        "#{tuple[0]}=#{encodeURIComponent(tuple[1])}"
      .value()
      .join('&')

module.exports = Request
