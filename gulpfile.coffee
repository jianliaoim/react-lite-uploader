
fs = require 'fs'
gulp = require 'gulp'
gutil = require 'gulp-util'
config = require 'config'
webpack = require 'webpack'
sequence = require 'run-sequence'
WebpackDevServer = require 'webpack-dev-server'

gulp.task 'script', ->
  coffee = require('gulp-coffee')
  gulp
  .src 'src/*.coffee'
  .pipe coffee()
  .pipe gulp.dest('lib/')

gulp.task 'rsync', (cb) ->
  wrapper = require 'rsyncwrapper'
  wrapper.rsync
    ssh: true
    src: ['build/*']
    recursive: true
    args: ['--verbose']
    dest: 'talk-ui:/teambition/server/talk-ui/coffee-webpack-starter'
    deleteAll: true
  , (error, stdout, stderr, cmd) ->
    if error?
      throw error
    console.error stderr
    console.log cmd
    cb()

gulp.task 'html', (cb) ->
  html = require('./entry/template')
  fs = require('fs')
  fs.writeFile 'build/index.html', html(), cb

gulp.task 'del', (cb) ->
  del = require('del')
  del 'build/**/*', cb

# webpack tasks

gulp.task 'webpack-dev', (cb) ->
  webpackDev = require './packing/webpack-dev'
  webpackServer =
    publicPath: '/'
    hot: true
    stats:
      colors: true
  info =
    __dirname: __dirname
    env: config.env

  compiler = webpack (webpackDev info)
  server = new WebpackDevServer compiler, webpackServer

  server.listen config.webpackDevPort, 'localhost', (err) ->
    if err?
      throw new gutil.PluginError("webpack-dev-server", err)
    gutil.log "[webpack-dev-server] is running..."
    cb()

gulp.task 'webpack-build', (cb) ->
  webpackBuild = require './packing/webpack-build'
  info =
    __dirname: __dirname
    isMinified: config.isMinified
    useCDN: config.useCDN
    cdn: config.cdn
    env: config.env
  webpack (webpackBuild info), (err, stats) ->
    if err
      throw new gutil.PluginError("webpack", err)
    gutil.log '[webpack]', stats.toString()
    fileContent = JSON.stringify stats.toJson().assetsByChunkName
    fs.writeFileSync 'packing/assets.json', fileContent
    cb()

# aliases

gulp.task 'dev', (cb) ->
  sequence 'html', 'webpack-dev', cb

gulp.task 'build', (cb) ->
  gutil.log gutil.colors.yellow("Running Gulp in `#{config.env}` mode!")
  sequence 'del', 'webpack-build', 'html', cb
