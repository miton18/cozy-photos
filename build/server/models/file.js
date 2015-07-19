// Generated by CoffeeScript 1.9.3
var File, cozydb,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

cozydb = require('cozydb');

module.exports = File = (function(superClass) {
  extend(File, superClass);

  function File() {
    return File.__super__.constructor.apply(this, arguments);
  }

  File.schema = {
    id: String,
    name: String,
    path: String,
    lastModification: String,
    binary: cozydb.NoSchema,
    "class": String
  };

  File.imageByDate = function(options, callback) {
    return File.request('imageByDate', options, callback);
  };

  File.withoutThumb = function(callback) {
    return File.request('withoutThumb', {}, callback);
  };

  return File;

})(cozydb.CozyModel);
