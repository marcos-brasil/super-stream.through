var Promise, Transform, async, bufferMode, chai, expect, mode, objectMode, sinon, through, _fn, _i, _len, _ref, _ref1;

Transform = require("readable-stream").Transform;

Promise = require("es6-promise").Promise;

chai = require("chai");

sinon = require("sinon");

chai.use(require("sinon-chai"));

expect = chai.expect;

chai.config.showDiff = false;

through = require("./through");

_ref = require("./fixture"), bufferMode = _ref.bufferMode, objectMode = _ref.objectMode, async = _ref.async;

describe("exported value:", function() {
  it('must be a function', function() {
    return expect(through).to.be.an["instanceof"](Function);
  });
  it("should have obj property", function() {
    expect(through).to.have.property("obj");
    return expect(through.factory).to.be.an["instanceof"](Function);
  });
  it("should have ctor property", function() {
    expect(through).to.have.property("ctor");
    return expect(through.factory).to.be.an["instanceof"](Function);
  });
  return it("should have factory property", function() {
    expect(through).to.have.property("factory");
    return expect(through.factory).to.be.an["instanceof"](Function);
  });
});

_ref1 = [bufferMode, objectMode];
_fn = function(mode) {
  return describe(mode.desc, function() {
    beforeEach(mode.before(through));
    afterEach(mode.after);
    it("must return an instanceof Transform", function() {
      var stream, _j, _len1, _ref2, _results;
      _ref2 = this.streamsArray;
      _results = [];
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        stream = _ref2[_j];
        _results.push(expect(stream).to.be.an["instanceof"](Transform));
      }
      return _results;
    });
    it("must pass data through stream unchanged", function(done) {
      this.stA.pipe(this.thr((function(_this) {
        return function() {
          expect(_this.spyA).to.have.been.calledOnce.and.calledWith(_this.data1);
          return done();
        };
      })(this)));
      return this.stA.write(this.data1);
    });
    return it("must be able to re-use the same multiple times", function(done) {
      return Promise.all([async(this.data1, this.stA), async(this.data2, this.stA)]).then((function(_this) {
        return function() {
          expect(_this.spyA).to.have.been.calledTwice;
          expect(_this.spyA).to.have.been.calledWith(_this.data1);
          expect(_this.spyA).to.have.been.calledWith(_this.data2);
          return done();
        };
      })(this))["catch"](done);
    });
  });
};
for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
  mode = _ref1[_i];
  _fn(mode);
}
