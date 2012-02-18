(function() {
  var Bezos, Request, Response, crypto, http;

  Bezos = require('bezos');

  crypto = require('crypto');

  http = require('http');

  Response = require('./response');

  Request = (function() {

    Request.prototype.CURRENT_API_VERSION = '2011-08-01';

    Request.prototype.HOSTS = {
      ca: 'ecs.amazonaws.ca',
      cn: 'webservices.amazon.cn',
      de: 'ecs.amazonaws.de',
      es: 'webservices.amazon.es',
      fr: 'ecs.amazonaws.fr',
      it: 'webservices.amazon.it',
      jp: 'ecs.amazonaws.jp',
      uk: 'ecs.amazonaws.co.uk',
      us: 'ecs.amazonaws.com'
    };

    function Request(options) {
      this.locale = options.locale || 'us';
      this._key = options.key || (function() {
        throw 'Missing key';
      })();
      this._secret = options.secret || (function() {
        throw 'Missing secret';
      })();
      this._tag = options.tag || (function() {
        throw 'Missing associate tag';
      })();
      this.reset();
    }

    Request.prototype.add = function(params) {
      var key, val;
      for (key in params) {
        val = params[key];
        if (val.constructor === Array) val = val.join(',');
        key = key[0].toUpperCase() + key.slice(1);
        this._params[key] = val;
      }
      return this;
    };

    Request.prototype.get = function(callback) {
      var options;
      options = {
        host: this.host(),
        path: this.path()
      };
      http.get(options, function(res) {
        var data;
        data = '';
        return res.on('data', function(chunk) {
          return data += chunk;
        }).on('end', function() {
          return callback(null, new Response(data, res.statusCode));
        }).on('error', function(e) {
          return callback(e);
        });
      });
    };

    Request.prototype.host = function() {
      return this.HOSTS[this.locale] || (function() {
        throw 'Bad locale';
      })();
    };

    Request.prototype.path = function() {
      return new Bezos(this._secret).sign(this.host(), '/onca/xml', this._params);
    };

    Request.prototype.reset = function() {
      this._params = {
        AWSAccessKeyId: this._key,
        AssociateTag: this._tag,
        Service: 'AWSECommerceService',
        Timestamp: new Date().toISOString(),
        Version: this.CURRENT_API_VERSION
      };
      return this;
    };

    Request.prototype.url = function() {
      return "http://" + (this.host()) + (this.path());
    };

    return Request;

  })();

  module.exports = Request;

}).call(this);
