###*
  * @module through
  * @author Marcos GJ 
  * @license MIT
  ###

through2 = require "through2"
isFunction = require "lodash.isfunction"
defaults = require "lodash.defaults"

###*
  * @global
  * @private
  * @type Object
  * @desc default options passed to `through2` if none is provided
  ###
OPTIONS = {}

###*
  * @external Transform
  ###

###*
  * @instance

  * @param {Object=} options
  * @param {Number=} [options.highWaterMark = 16kb]- The maximum number of bytes to store in the internal buffer before ceasing to read from the underlying resource.
  * @param {?String=} [options.encoding = null] -  If specified, then buffers will be decoded to strings using the specified encoding.
  * @param {Boolean=} [options.objectMode = false] - Whether this stream should behave as a stream of objects. Meaning that stream.read(n) returns a single value instead of a Buffer of size n.

  * @param {Function=} transform - Transform function
  * @param {Function=} flush - Flush function

  * @return {Transform} - A `Transform` stream from `readable-stream` module

  * @desc A wrapper function around through2 

  ###
through = (options, transform, flush) ->
  if isFunction options
    flush = transform
    transform = options
    options = OPTIONS
  else
    options = defaults options, OPTIONS

  if arguments.length is 0
    options = OPTIONS

  return through2 options, transform, flush

###* 
  * @static
  * @type Function
  * @method
  * @return {Transform} - A `Transform` stream from `readable-stream` module

  * @desc `ctor` method from through2
  ###
ctor = -> through2.ctor.apply @, arguments

###* 
  * @static
  * @type Function
  * @return {Transform} - A `Transform` stream from `readable-stream` module

  * @desc `obj` method from through2
  ###
obj = -> through2.obj.apply @, arguments

###* 
  * @static
  * @type Function

  * @param {Object=} options
  * @param {Number=} [options.highWaterMark = 16kb]- The maximum number of bytes to store in the internal buffer before ceasing to read from the underlying resource.
  * @param {?String=} [options.encoding = null] -  If specified, then buffers will be decoded to strings using the specified encoding.
  * @param {Boolean=} [options.objectMode = false] - Whether this stream should behave as a stream of objects. Meaning that stream.read(n) returns a single value instead of a Buffer of size n.

  * @return {through} - A through function with `options` as default

  * @desc 

  ##\##\## example:
  ```coffee
  thrObj = through.factory {objectMode: yes}
  streamObj = thrObj (file, enc, done) ->
    expect(file).to.be.equal 'my data'

  streamObj.write 'my data'

  myData = new Buffer 'my data'
  streamBuf = through (file, enc, done) ->
    expect(file).to.be.equal myData

  streamObj.write 'data'

  ```
  ###
factory = (options = {}) ->
  OPTIONS = options

  through.factory = factory
  through.ctor = ctor
  through.obj = obj

  return through


module.exports = factory()
