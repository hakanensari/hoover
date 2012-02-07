(function() {
  var Response, libxmljs;

  libxmljs = require('libxmljs');

  Response = (function() {

    function Response(data, code) {
      this.code = code;
      this._root = libxmljs.parseXmlString(data.trim()).root();
      this._ns = this._root.namespace().href();
    }

    Response.prototype.find = function(key, passThrough) {
      var node, _i, _len, _ref, _results;
      _ref = this._root.find("//xmlns:" + key, this._ns);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        node = _ref[_i];
        if (passThrough) {
          _results.push(passThrough(this._parse(node)));
        } else {
          _results.push(this._parse(node));
        }
      }
      return _results;
    };

    Response.prototype.toObject = function() {
      return this._parse(this._root);
    };

    Response.prototype._parse = function(node) {
      var attr, child, key, obj, val, _i, _j, _len, _len2, _ref, _ref2;
      obj = {};
      _ref = node.attrs();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attr = _ref[_i];
        obj[attr.name()] = attr.value();
      }
      _ref2 = node.childNodes();
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        child = _ref2[_j];
        key = child.name();
        if (key === 'text') {
          val = child.text();
          if (Object.keys(obj).length === 0) {
            obj = val;
          } else {
            obj['__content'] = val;
          }
        } else {
          val = this._parse(child);
          if (obj[key]) {
            if (obj[key].constructor !== Array) obj[key] = [obj[key]];
            obj[key].push(val);
          } else {
            obj[key] = val;
          }
        }
      }
      return obj;
    };

    return Response;

  })();

  module.exports = Response;

}).call(this);
