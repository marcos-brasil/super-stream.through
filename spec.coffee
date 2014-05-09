{Transform} = require "readable-stream" 
{Promise} = require "es6-promise"

chai = require "chai"
sinon = require "sinon"
chai.use require "sinon-chai"

expect = chai.expect
chai.config.showDiff = no

through = require "./through"
{bufferMode, objectMode, async} = require "./fixture"

describe "exported value:", ->
  it 'must be a function', ->
    expect(through).to.be.an.instanceof Function

  it "should have obj property", ->
    expect(through).to.have.property "obj"
    expect(through.factory).to.be.an.instanceof Function

  it "should have ctor property", ->
    expect(through).to.have.property "ctor"
    expect(through.factory).to.be.an.instanceof Function

  it "should have factory property", ->
    expect(through).to.have.property "factory"
    expect(through.factory).to.be.an.instanceof Function

for mode in [bufferMode, objectMode]
  do (mode) ->
    describe mode.desc, ->
      beforeEach mode.before through
      afterEach mode.after

      it "must return an instanceof Transform", ->
        for stream in @streamsArray
          expect(stream).to.be.an.instanceof Transform

      it "must pass data through stream unchanged", (done) ->
        @stA.pipe @thr =>
          expect(@spyA).to.have.been.calledOnce.and.calledWith @data1
          done()
        
        @stA.write @data1

      it "must be able to re-use the same multiple times", (done) ->
        Promise.all [async(@data1, @stA), async(@data2, @stA)]
          .then =>
            expect(@spyA).to.have.been.calledTwice
            expect(@spyA).to.have.been.calledWith @data1
            expect(@spyA).to.have.been.calledWith @data2
            done()
          .catch done

