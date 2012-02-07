(function() {
  var Request, Response, crypto, http;

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
        path: "/onca/xml?" + (this._query())
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

    Request.prototype._query = function() {
      var hmac, k, query, signature, v;
      query = ((function() {
        var _ref, _results;
        _ref = this._params;
        _results = [];
        for (k in _ref) {
          v = _ref[k];
          _results.push("" + k + "=" + (encodeURIComponent(v)));
        }
        return _results;
      }).call(this)).sort().join('&');
      hmac = crypto.createHmac('sha256', this._secret);
      hmac.update(['GET', this.host(), '/onca/xml', query].join("\n"));
      signature = hmac.digest('base64');
      return "" + query + "&Signature=" + (encodeURIComponent(signature));
    };

    return Request;

  })();

  module.exports = Request;

}).call(this);
