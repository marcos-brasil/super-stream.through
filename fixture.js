var Promise, async, bufferMode, extendCtx, objectMode, sinon, through;

through = require("./through");

sinon = require("sinon");

Promise = require("es6-promise").Promise;


/* istanbul ignore next */

extendCtx = function() {
  this.streamsArray = [this.thr(), this.thr(), this.thr()];
  this.spyA = sinon.spy();
  return this.stA = this.thr((function(_this) {
    return function(c, e, n) {
      _this.spyA(c);
      return n(null, c);
    };
  })(this));
};

bufferMode = {

  /* istanbul ignore next */
  before: function(fn) {
    return function() {
      this.opt = {};
      this.data1 = new Buffer("data1");
      this.data2 = new Buffer("data2");
      this.thr = fn.factory(this.opts);
      extendCtx.call(this);
      return this;
    };
  },
  after: function() {},
  desc: 'streams in buffer mode:'
};

objectMode = {

  /* istanbul ignore next */
  before: function(fn) {
    return function() {
      this.opts = {
        objectMode: true
      };
      this.data1 = "data1";
      this.data2 = "data2";
      this.thr = fn.factory(this.opts);
      extendCtx.call(this);
      return this;
    };
  },
  after: function() {},
  desc: 'streams in object mode:'
};


/* istanbul ignore next */

async = function(data, stream) {
  return new Promise(function(res, rej) {
    stream.write(data);
    return setImmediate(res);
  });
};

module.exports = {
  bufferMode: bufferMode,
  objectMode: objectMode,
  async: async
};
