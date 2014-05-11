
# Through
<!-- [![NPM][NPM1][NPM2]] -->

<!-- [![Build Status][1]][2] [![dependency status][3]][4] [![dev dependency status][5]][6] -->

### A basic wrapper function around [`through2@0.4.x`](https://github.com/rvagg/through2)

This is the base function used by [`super-stream`](https://github.com/markuz-gj/super-stream) as a standalone module. Also it is a drop in replacement for `through2`

Why shouldn't you use `through2` instead of this module?  
You wouldn't if all you need is a basic helper for creating [`stream.Transform`](http://nodejs.org/api/stream.html#stream_class_stream_transform).

But if you need some functional style transforms and other stream utilities and reduce your dependencies at the same time, **_this_** is your basic through stream you are looking for.

See also ...


#### Basic usage:

```javascript
var expect = require('chai').expect;

var streamA = through.obj(function(counter, enc, done){
  counter += 1;
  done(null, counter);
});
var streamB = through({objectMode: true}, function(counter, enc, done){
  counter += 1;
  done(null, counter);
});

thr = through.factory({objectMode: true});

streamA.pipe(streamB).pipe(thr(function(counter, enc, done){
  expect(counter).to.be.equal(2);
}));

streamA.write(0);
```

```javascript
var streamA = through(function(chunk, enc, done){
  data = chunk.toString();
  done(null, new Buffer(data +'-'+ data));
});

thrObj = through.factory({objectMode: true});
var streamB = thrObj.buf(function(chunk, enc, done){
  expect(chunk.toString()).to.be.equal('myData-myData');
  done();
});

streamA.write(new Buffer('myData'));
```

#### _ through.ctor([options], [transformFn], [flushFn]); _
Note: This is the same `ctor` method from `through2`  
If called without arguments, returns a passthrough `Transform` 

```javascript
var Ctor = through.ctor({objectMode: true}, transformFn, flushFn);
streamA = new Ctor();

// no need for the new operator
streamB = Ctor(); 

//overriding options
streamC = Ctor({objectMode: false}); 

```

#### _ through.obj([transfromFn], [flushFn]) _
It is a conveniece method for `through({objectMode: true}, transformFn, flushFn);`  
If called without arguments, returns a passthrough `Transform` 

Note: This is the same `obj` method from `through2`

```javascript
var streamObj = thr.obj(function(string, enc, done){
  expect(string).to.be.deep.equal({data: 'myData'});
  done();
});
streamObj.write({data: 'myData'});
```

#### _ through.buf([transfromFn], [flushFn]) _
It is a conveniece method for `through({objectMode: false}, transformFn, flushFn);`  
If called without arguments, returns a passthrough `Transform` 

```javascript
// see the factory method.
var thr = through.factory({objectMode: true});
var myData = new Buffer('my data');

var streamBuf = thr.buf(function(chunk, enc, done){
  expect(chunk).to.be.equal(myData);
  expect(chunk).to.not.be.equal('my data');
  done();
}):
streamBuf.write(myData);
```

#### _ through.factory([options]); _
A factory method for creating a custom `through` instance.  

```javascript
var thrObj = through.factory({objectMode: true});

var streamObj = thrObj(function(string, enc, done){
  expect(string).to.be.equal('my data');
  done();
});
streamObj.write('my data');
```

```javascript
var myData = new Buffer('my data');
var thrBuf = through.factory({objectMode: false, highWaterMark: 1000*Math.pow(2,6)});

var streamBuf = thrBuf(function(chunk, enc, done){
  expect(chunk).to.be.equal(myData);
  expect(chunk).to.not.be.equal('my data');
  done();
}):
streamBuf.write(myData);
```