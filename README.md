# Through



[![NPM version](https://badge.fury.io/js/super-stream.through.png)](https://npmjs.org/package/super-stream.through) [![Build Status](https://travis-ci.org/markuz-gj/super-stream.through.png?branch=master)](https://travis-ci.org/markuz-gj/super-stream.through) [![Dependency Status](https://david-dm.org/markuz-gj/super-stream.through.png)](https://david-dm.org/markuz-gj/super-stream.through) [![devDependency Status](https://david-dm.org/markuz-gj/super-stream.through/dev-status.png)](https://david-dm.org/markuz-gj/super-stream.through#info=devDependencies) [![Coverage Status](https://coveralls.io/repos/markuz-gj/super-stream.through/badge.png?branch=master)](https://coveralls.io/r/markuz-gj/super-stream.through?branch=master) [![MIT Licensed](http://img.shields.io/badge/license-MIT-blue.svg)](#license) 

<!-- [![endorse](https://api.coderwall.com/markuz-gj/endorsecount.png)](https://coderwall.com/markuz-gj) -->

#### A basic wrapper function around [`through2@0.4.x`](https://github.com/rvagg/through2)

This is the base function used by [`super-stream`](https://github.com/markuz-gj/super-stream) as a standalone module. Also it is a drop in replacement for `through2`

Why shouldn't you use `through2` instead of this module?  
You wouldn't if all you need is a basic helper for creating [`stream.Transform`](http://nodejs.org/api/stream.html#stream_class_stream_transform).

But if you need some functional style transforms and other stream utilities and reduce your dependencies at the same time, **_this_** is your basic through stream you are looking for. For all the API, go [here](http://markuz-gj.github.io/super-stream.through/)  

### Not ready yet.

See also.  
[`super-stream`](https://github.com/markuz-gj/super-stream)  
[`super-stream.each`](https://github.com/markuz-gj/super-stream.each)  
[`super-stream.map`](https://github.com/markuz-gj/super-stream.map)  
[`super-stream.reduce`](https://github.com/markuz-gj/super-stream.reduce)  
[`super-stream.filter`](https://github.com/markuz-gj/super-stream.filter)  
[`super-stream.junction`](https://github.com/markuz-gj/super-stream.junction)  
[`super-stream.pipeline`](https://github.com/markuz-gj/super-stream.pipeline)  

* * *


#### _through([options,] [transformFn,] [flushFn]);_

##### this is how



```javascript

var expect = require('chai').expect;
var through = require("super-stream.through")

var streamA = through.obj(function(counter, enc, done){
  counter += 1;
  done(null, counter);
});
var streamB = through({objectMode: true}, function(counter, enc, done){
  counter += 1;
  done(null, counter);
});

var thr = through.factory({objectMode: true});

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
 
streamA.pipe(streamB);
streamA.write(new Buffer('myData'));

```


#### _through.ctor([options,] [transformFn,] [flushFn]);_



Note: This is the same `ctor` method from `through2`  
If called without arguments, returns a passthrough `Transform` 



```javascript
var Transform = require('readable-stream').Transform;
var Ctor = through.ctor({objectMode: true}, transformFn, flushFn);
var streamA = new Ctor();

// no need for the new operator
var streamB = Ctor(); 

//overriding options
var streamC = Ctor({objectMode: false}); 

expect(streamA).to.be.an.instanceof(Transform);
expect(streamB).to.be.an.instanceof(Transform);
expect(streamC).to.be.an.instanceof(Transform);

```


#### _through.obj([transfromFn,] [flushFn])_



It is a conveniece method for `through({objectMode: true}, transformFn, flushFn);`  
If called without arguments, returns a passthrough `Transform` 

Note: This is the same `obj` method from `through2`



```javascript
var stream = through.obj(function(string, enc, done){
  expect(string).to.be.deep.equal({data: 'myData'});
  done();
});
stream.write({data: 'myData'});
```


#### _through.buf([transfromFn,] [flushFn])_


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
});
streamBuf.write(myData);
```


#### _through.factory([options]);_



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
});
streamBuf.write(myData);
```

License
---

The MIT License (MIT)

Copyright (c) 2014 Markuz GJ

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[![NPM](https://nodei.co/npm/super-stream.through.png)](https://nodei.co/npm/super-stream.through/) [![NPM](https://nodei.co/npm-dl/super-stream.through.png)](https://nodei.co/npm/super-stream.through/)