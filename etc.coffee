###*
 * @module super-stream/etc
 * @author Marcos GJ 
 * @license MIT
 * @desc some helper functions
 ###

path = require "path"
{exec} = require "child_process"
{Promise} = require "es6-promise"

gulp = require "gulp"
{colors, log, replaceExtension} = require "gulp-util"
{bold, red, magenta} = colors

coffee = require "gulp-coffee"
jsdoc = require "gulp-jsdoc"

express = require "express"
livereload = require "gulp-livereload"
tinylr = require "tiny-lr"
conn = require "connect"

through = require './through'
thr = through.obj

###*
 * @type Function
 * @param {String} code - code value to be passed to process.exit
 ###
reboot = (evt, code = 0) ->
  if evt.type is 'changed'
    log bold red "::: Existing gulp task now :::"
    process.exit code

###*
 * @type Function
 * @param {Object, VFS} - TODO: fix this types
 ###
logFile = (evt) ->
  if evt._startTime
    timedif = prettyHrtime process.hrtime(evt._startTime)

  file = "./#{path.relative process.cwd(), evt.path}"
  msg = "file #{magenta file} was #{evt.type || "created in #{magenta timedif}"}"
  log msg
  return file

###*
 * @type Transform
 * @desc A transform stream for the purpose of logging
 ###
logStream = thr (f) ->
  logFile f
  @push f

###*
 * @type Function
 * @param {String} cmd - a shell command to be passed to child_process.exec
 * @returns {Promise}
 ###
shell = (cmd) ->
  promise = new Promise (resolve, reject) ->
    cache =
      stdout: []
      stderr: []

    stream = exec cmd
    stream.on "error", reject

    stream.stdout.pipe thr (f,e,n) -> cache.stdout.push f; n()
    stream.stderr.pipe thr (f,e,n) -> cache.stderr.push f; n()

    stream.on "close", (code) ->
      str = cache.stdout.join ''
      str = "#{str}\n#{cache.stderr.join ''}"
      resolve(str)

###*
 * @type Function
 * @param {String} spec - filename of the test to be run
 * @returns {Function}
 ###
mocha =  (spec) ->
  ->
    cmd = "./node_modules/mocha/bin/mocha  --compilers coffee:coffee-script/register #{spec} -R spec -t 1000 "
    shell cmd
      .catch (err) ->
        throw new Error err
      .then (str) ->
        console.log str

###*
 * @type Function
 * @param {String} spec - filename of the test to be run
 * @returns {Function}
 ###
istanbul = (spec) ->
  spec = replaceExtension spec, ".js"
  ->
    cmd = "./node_modules/istanbul/lib/cli.js cover --report html ./node_modules/mocha/bin/_mocha -- #{spec} -R dot -t 1000"
    log "shell running istanbul"
    
    shell cmd
      .catch (err) ->
        throw new Error err
      .then (str) ->
        console.log "\nIstanbul coverage summary:"
        console.log "==========================\n"
        console.log str.split('\n')[7..10].join('\n')
        fpath = "#{str.split('\n')[-3..-3].join('').split(' ')[4].split('')[1..-2].join('')}/index.html"
        console.log "\nopen:", "./#{path.relative process.cwd(), fpath}"

###*
 * @type Function
 * @param {String} glob - glob pattern to watch
 * @returns {Function} 
 ###
server = (glob) ->
  globs = [glob, "./coverage/index.html", './jsdoc/index.html']
  app = express()

  app.use require('connect-livereload')()
  app.use '/coverage', express.static(path.resolve './coverage')
  app.use '/jsdoc', express.static(path.resolve './jsdoc')
  app.use conn.errorHandler {dumpExceptions: true, showStack: true }

  app.get 
  app.listen 3001, ->
    log bold "express server running on port: #{magenta 3001}"

  serverLR = tinylr {
    liveCSS: off
    liveJs: off
    LiveImg: off
  }

  lrUp = new Promise (resolve, reject) ->
    serverLR.listen 35729, (err) ->
     return reject err if err
     resolve()

  ->
    gulp.watch globs, (evt) ->
      lrUp.then ->
        log 'LR: reloading....'
        gulp.src evt.path
          .pipe livereload serverLR

###*
 * @type Function
 * @param {String} glob - glob pattern to watch
 * @returns {Function} 
 ###
compileDoc = (src) ->
  template = {
    path: 'ink-docstrap'
    systemName: 'super-stream'
    footer: 'lol - my footer'
    copyright: "my copyright"
    navType: "vertical"
    theme: "spacelab"
    linenums: yes
    collapseSymbols: no
    inverseNav: no
  }

  config =
    plugins: ['plugins/markdown']
    markdown: 
      parser: 'gfm'
      hardwrap: yes

  -> 
    gulp.src replaceExtension(src, '.js')
      .pipe through.obj (f,e,n) ->
        f.contents = new Buffer f.contents.toString().replace(/\\#/g,'#').replace('\*#', '##')
        n null, f
      .pipe jsdoc.parser config
      .pipe jsdoc.generator 'jsdoc'

###*
 * @type Function
 * @param {String} glob - glob pattern to watch
 * @returns {Function} 
 ###
compileCoffee = (globs) ->
  -> 
    gulp.src globs
      .pipe coffee {bare: yes}
      .pipe gulp.dest('.')

module.exports =
  shell: shell
  logFile: logFile
  mocha: mocha
  istanbul: istanbul
  reboot: reboot
  server: server
  jsdoc: compileDoc
  coffee: compileCoffee

