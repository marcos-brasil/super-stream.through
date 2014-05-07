through = require "./through"
sinon = require "sinon"
{Promise} = require "es6-promise"

### istanbul ignore next ###
extendCtx = ->
  @streamsArray = [@thr(), @thr(), @thr()]
  @spyA = sinon.spy()
  @stA = @thr (c,e,n) =>
    @spyA c
    n null, c

bufferMode = 
  ### istanbul ignore next ###
  before: (fn) ->
    ->
      @opt = {}
      @data1 = new Buffer "data1"
      @data2 = new Buffer "data2"

      @thr = fn.factory @opts
      extendCtx.call @

      return @

  after: ->
  desc: 'streams in buffer mode:'

objectMode = 
  ### istanbul ignore next ###
  before: (fn) ->
    ->
      @opts = {objectMode: yes}
      @data1 = "data1"
      @data2 = "data2"

      @thr = fn.factory @opts
      extendCtx.call @

      return @
    
  after: ->
  desc: 'streams in object mode:'

### istanbul ignore next ###
async = (data, stream) ->
  new Promise (res, rej) ->
    stream.write data
    setImmediate res

module.exports = {
  bufferMode: bufferMode
  objectMode: objectMode
  async: async
}