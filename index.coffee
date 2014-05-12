###*
  * @module through
  * @author Markuz GJ 
  * @license MIT
  * @description 
  * # Through
  *
  * [![NPM version](https://badge.fury.io/js/super-stream.through.png)](https://npmjs.org/package/super-stream.through) [![Build Status](https://travis-ci.org/markuz-gj/super-stream.through.png?branch=master)](https://travis-ci.org/markuz-gj/super-stream.through) [![Dependency Status](https://david-dm.org/markuz-gj/super-stream.through.png)](https://david-dm.org/markuz-gj/super-stream.through) [![devDependency Status](https://david-dm.org/markuz-gj/super-stream.through/dev-status.png)](https://david-dm.org/markuz-gj/super-stream.through#info=devDependencies) [![Coverage Status](https://coveralls.io/repos/markuz-gj/super-stream.through/badge.png?branch=master)](https://coveralls.io/r/markuz-gj/super-stream.through?branch=master)
  * 
  * ##\# A basic wrapper function around [`through2@0.4.x`](https://github.com/rvagg/through2)
  *
  * This is the base function used by [`super-stream`](https://github.com/markuz-gj/super-stream) as a standalone module. Also it is a drop in replacement for `through2`
  *
  * Why shouldn't you use `through2` instead of this module?  
  * You wouldn't if all you need is a basic helper for creating [`stream.Transform`](http://nodejs.org/api/stream.html#stream_class_stream_transform).
  *
  * But if you need some functional style transforms and other stream utilities and reduce your dependencies at the same time, **_this_** is your basic through stream you are looking for.
  * 
  * See also ...
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
  * @desc 

  * ##\## Basic usage:
  *
  * ```javascript
  * var expect = require('chai').expect;
  *
  * var streamA = through.obj(function(counter, enc, done){
  *   counter += 1;
  *   done(null, counter);
  * });
  * var streamB = through({objectMode: true}, function(counter, enc, done){
  *   counter += 1;
  *   done(null, counter);
  * });
  *
  * thr = through.factory({objectMode: true});
  *
  * streamA.pipe(streamB).pipe(thr(function(counter, enc, done){
  *   expect(counter).to.be.equal(2);
  * }));
  *
  * streamA.write(0);
  * ```
  *
  * ```javascript
  * var streamA = through(function(chunk, enc, done){
  *   data = chunk.toString();
  *   done(null, new Buffer(data +'-'+ data));
  * });
  *
  * thrObj = through.factory({objectMode: true});
  * var streamB = thrObj.buf(function(chunk, enc, done){
  *   expect(chunk.toString()).to.be.equal('myData-myData');
  *   done();
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
  * ##\## _ through.ctor([options], [transformFn], [flushFn]); _
  * Note: This is the same `ctor` method from `through2`  
  * If called without arguments, returns a passthrough `Transform` 
  *
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
  * ##\## _ through.obj([transfromFn], [flushFn]) _
  * It is a conveniece method for `through({objectMode: true}, transformFn, flushFn);`  
  * If called without arguments, returns a passthrough `Transform` 
  *
  * Note: This is the same `obj` method from `through2`
  *
  * ```javascript
  * var streamObj = thr.obj(function(string, enc, done){
  *   expect(string).to.be.deep.equal({data: 'myData'});
  *   done();
  * });
  * streamObj.write({data: 'myData'});
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
  * ##\## _ through.buf([transfromFn], [flushFn]) _
  * It is a conveniece method for `through({objectMode: false}, transformFn, flushFn);`  
  * If called without arguments, returns a passthrough `Transform` 
  *
  * ```javascript
  * // see the factory method.
  * var thr = through.factory({objectMode: true});
  * var myData = new Buffer('my data');

  * var streamBuf = thr.buf(function(chunk, enc, done){
  *   expect(chunk).to.be.equal(myData);
  *   expect(chunk).to.not.be.equal('my data');
  *   done();
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
  * ##\## _ through.factory([options]); _
  * A factory method for creating a custom `through` instance.  
  *
  * ```javascript
  * var thrObj = through.factory({objectMode: true});
  *
  * var streamObj = thrObj(function(string, enc, done){
  *   expect(string).to.be.equal('my data');
  *   done();
  * });
  * streamObj.write('my data');
  * ```
  *
  * ```javascript
  * var myData = new Buffer('my data');
  * var thrBuf = through.factory({objectMode: false, highWaterMark: 1000*Math.pow(2,6)});
  *
  * var streamBuf = thrBuf(function(chunk, enc, done){
  *   expect(chunk).to.be.equal(myData);
  *   expect(chunk).to.not.be.equal('my data');
  *   done();
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

###*
  * README.md's footer
  * @desc
  * [![NPM](https://nodei.co/npm/super-stream.through.png)](https://nodei.co/npm/super-stream.through/) [![NPM](https://nodei.co/npm-dl/super-stream.through.png)](https://nodei.co/npm/super-stream.through/)
  ###


module.exports = factory()
