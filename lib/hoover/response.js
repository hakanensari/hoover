(function() {
  var Response, crack;

  crack = require('crack');

  Response = (function() {

    function Response(data, code) {
      this.code = code;
      this._doc = crack(data);
    }

    Response.prototype.find = function(key, process) {
      return this._doc.find(key, process);
    };

    Response.prototype.toJS = function() {
      return this._doc.toJS();
    };

    return Response;

  })();

  module.exports = Response;

}).call(this);
