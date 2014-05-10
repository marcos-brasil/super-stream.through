###*
  * @module through
  * @author Marcos GJ 
  * @license MIT
  ###

through2 = require "through2"
isFunction = require "lodash.isfunction"
defaults = require "lodash.defaults"


###*
  * @instance
  *
  * @param {Object=} options - Same options as seen [here](/jsdoc/module-through.html#factory)
  * @param {Function=} transform - `_transform` function as described [here](http://nodejs.org/docs/latest/api/stream.html#stream_class_stream_transform)
  * @param {Function=} flush - `_flush` function as described [here](http://nodejs.org/docs/latest/api/stream.html#stream_class_stream_transform) (same link as above)
  * @return {transformStream} - A instance of `Transform` stream from `readable-stream@1.0.x`
  *
  * @desc A wrapper function around `through2@0.4.x`
  *
  * ##\##\## example 01:
  * ```javascript
  * var streamA = through.obj(function(counter, enc, done){
  *   counter += 1;
  *   done(null, counter);
  * });
  * var streamB = through({objectMode: true}, function(counter, enc, done){
  *   counter += 1;
  *   done(null, counter)
  * });
  *
  * thrObj = through.factory({objectMode: true});
  * streamA.pipe(streamB).pipe(thrObj(function(counter, enc, done){
  *   expect(counter).to.be.equal(2);
  * }));
  *
  * streamA.write(0);
  * ```
  *
  * ##\##\## example 02:
  * ```javascript
  * var streamA = through(function(chunk, enc, done){
  *   data = chunk.toString();
  *   done(null, new Buffer(data +'-'+ data));
  * });
  *
  * thrObj = through.factory({objectMode: true});
  * var streamB = thrObj.buf(function(chunk, enc, done){
  *   expect(chunk.toString()).to.be.equal('myData-myData');
  * });
  *
  * streamA.write(new Buffer('myData'));
  * ```
  ###
through = (cfg) ->
  (options, transform, flush) ->
    if isFunction options
      flush = transform
      transform = options
      options = cfg
    else
      options = defaults options, cfg

    if arguments.length is 0
      options = cfg

    return through2 options, transform, flush

###* 
  * @static
  * @param {Object=} options - Same options as seen [here](/jsdoc/module-through.html#factory)
  * @param {Function=} transform - `_transform` function as described [here](http://nodejs.org/docs/latest/api/stream.html#stream_class_stream_transform)
  * @param {Function=} flush - `_flush` function as described [here](http://nodejs.org/docs/latest/api/stream.html#stream_class_stream_transform) (same link as above)
  * @return {Transform} - A pre-configured `Transform` contructor from `readable-stream@1.0.x`
  *
  * @desc 
  * `ctor` method from `through2@0.4.x`
  *
  * ##\##\## example:
  * ```javascript
  * var Ctor = through.ctor({objectMode: true}, transformFn, flushFn);
  * streamA = new Ctor();
  *
  * // no need for the new operator
  * streamB = Ctor(); 
  *
  * //overriding options
  * streamC = Ctor({objectMode: false}); 
  *
  * ```
  ###
ctor = (options, transform, flush) -> through2.ctor options, transform, flush

###* 
  * @static
  * @param {Function=} transform - `_transform` function as described [here](http://nodejs.org/docs/latest/api/stream.html#stream_class_stream_transform)
  * @param {Function=} flush - `_flush` function as described [here](http://nodejs.org/docs/latest/api/stream.html#stream_class_stream_transform) (same link as above)
  * @return {transformStream} - A instance of `Transform` stream from `readable-stream@1.0.x`
  *
  * @desc 
  * `obj` method from `through2@0.4.x`
  *
  * It is a conveniece method for `through({objectMode: true}, transformFn, flushFn);`
  *
  * ##\##\## example:
  *
  * ```javascript
  * var thr = through.factory({objectMode: false});
  *
  * var streamObj = thr.obj(function(string, enc, done){
  *   expect(string).to.be.equal('my data');
  *   done()
  * });
  * streamObj.write('my data');
  * ```
  ###
obj = (transform, flush) -> through2.obj transform, flush

###* 
  * @static
  * @param {Function=} transform - `_transform` function as described [here](http://nodejs.org/docs/latest/api/stream.html#stream_class_stream_transform)
  * @param {Function=} flush - `_flush` function as described [here](http://nodejs.org/docs/latest/api/stream.html#stream_class_stream_transform) (same link as above)
  * @return {transformStream} - A instance of `Transform` stream from `readable-stream@1.0.x`
  *
  * @desc 
  * It is a conveniece method for `through({objectMode: false}, transformFn, flushFn);`
  *
  * ##\##\## example:
  *
  * ```javascript
  * var thr = through.factory({objectMode: true});
  * var myData = new Buffer('my data');

  * var streamBuf = thr.buf(function(chunk, enc, done){
  *   expect(chunk).to.be.equal(myData);
  *   expect(chunk).to.not.be.equal(new Buffer('my data'));
  *   done()
  * }):
  * streamBuf.write(myData);
  * ```
  ###
buf = (transform, flush) -> through2 {objectMode: no}, transform, flush

###* 
  * @static
  *
  * @param {Object=} options - Object passed to `stream.Transfrom` constructor as described [here](http://nodejs.org/docs/latest/api/stream.html#stream_new_stream_readable_options) and [here](http://nodejs.org/docs/latest/api/stream.html#stream_new_stream_duplex_options)
  * @param {Number=} [options.highWaterMark = 16kb]- The maximum number of bytes to store in the internal buffer before ceasing to read from the underlying resource.
  * @param {?String=} [options.encoding = null] -  If specified, then buffers will be decoded to strings using the specified encoding.
  * @param {Boolean=} [options.objectMode = false] - Whether this stream should behave as a stream of objects. Meaning that stream.read(n) returns a single value instead of a Buffer of size n.
  * @param {Boolean=} [options.allowHalfOpen = true] - If set to false, then the stream will automatically end the readable side when the writable side ends and vice versa.
  * @return {through} - A through function with `options` pre-configured as default
  *
  * @desc 
  * A factory method for creating a custom `through` instance.
  *
  * ##\##\## example 01:
  *
  * ```javascript
  * var thrObj = through.factory({objectMode: true});
  *
  * var streamObj = thrObj(function(string, enc, done){
  *   expect(string).to.be.equal('my data');
  *   done()
  * });
  * streamObj.write('my data');
  * ```
  * ##\##\## example 02:
  *
  * ```javascript
  * var myData = new Buffer('my data');
  * var thrBuf = through.factory({objectMode: false, highWaterMark: 1000*Math.pow(2,6)});
  *
  * var streamBuf = thrBuf(function(chunk, enc, done){
  *   expect(chunk).to.be.equal(myData);
  *   expect(chunk).to.not.be.equal(new Buffer('my data'));
  *   done()
  * }):
  * streamBuf.write(myData);
  * ```
  ###
factory = (cfg = {}) ->
  fn = through cfg

  fn.factory = factory
  fn.ctor = ctor
  fn.obj = obj
  fn.buf = buf

  return fn

module.exports = factory()
