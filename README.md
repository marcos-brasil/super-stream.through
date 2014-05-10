# this awesome 


### A wrapper function around `through2@0.4.x`

###### example 01:
```javascript
var streamA = through.obj(function(counter, enc, done){
  counter += 1;
  done(null, counter);
});
var streamB = through({objectMode: true}, function(counter, enc, done){
  counter += 1;
  done(null, counter)
});

thrObj = through.factory({objectMode: true});
streamA.pipe(streamB).pipe(thrObj(function(counter, enc, done){
  expect(counter).to.be.equal(2);
}));

streamA.write(0);
```

###### example 02:
```javascript
var streamA = through(function(chunk, enc, done){
  data = chunk.toString();
  done(null, new Buffer(data +'-'+ data));
});

thrObj = through.factory({objectMode: true});
var streamB = thrObj.buf(function(chunk, enc, done){
  expect(chunk.toString()).to.be.equal('myData-myData');
});

streamA.write(new Buffer('myData'));
```

### `ctor` method from `through2@0.4.x`

###### example:
```javascript
var Ctor = through.ctor({objectMode: true}, transformFn, flushFn);
streamA = new Ctor();

// no need for the new operator
streamB = Ctor(); 

//overriding options
streamC = Ctor({objectMode: false}); 

```

### `obj` method from `through2@0.4.x`

It is a conveniece method for `through({objectMode: true}, transformFn, flushFn);`

###### example:

```javascript
var thr = through.factory({objectMode: false});

var streamObj = thr.obj(function(string, enc, done){
  expect(string).to.be.equal('my data');
  done()
});
streamObj.write('my data');
```

### It is a conveniece method for `through({objectMode: false}, transformFn, flushFn);`

###### example:

```javascript
var thr = through.factory({objectMode: true});
var myData = new Buffer('my data');

var streamBuf = thr.buf(function(chunk, enc, done){
  expect(chunk).to.be.equal(myData);
  expect(chunk).to.not.be.equal(new Buffer('my data'));
  done()
}):
streamBuf.write(myData);
```

### A factory method for creating a custom `through` instance.

###### example 01:

```javascript
var thrObj = through.factory({objectMode: true});

var streamObj = thrObj(function(string, enc, done){
  expect(string).to.be.equal('my data');
  done()
});
streamObj.write('my data');
```
###### example 02:

```javascript
var myData = new Buffer('my data');
var thrBuf = through.factory({objectMode: false, highWaterMark: 1000*Math.pow(2,6)});

var streamBuf = thrBuf(function(chunk, enc, done){
  expect(chunk).to.be.equal(myData);
  expect(chunk).to.not.be.equal(new Buffer('my data'));
  done()
}):
streamBuf.write(myData);
```