
fs = require('fs')
path = require 'path'
config = require 'config'
webpack = require 'webpack'

fontName = 'fonts/[name].[ext]'

module.exports = (info) ->
  entry:
    vendor: [
      "webpack-dev-server/client?http://localhost:#{config.webpackDevPort}"
      'webpack/hot/dev-server'
      'react'
    ]
    main: [
      './src/main'
    ]
  output:
    path: path.join info.__dirname, 'build'
    filename: '[name].js'
    publicPath: "http://localhost:#{config.webpackDevPort}/"
  resolve: extensions: ['.js', '.coffee', '']
  module:
    loaders: [
      {test: /\.coffee$/, loader: 'coffee'}
      {test: /\.less$/, loader: 'style!css!less'}
      {test: /\.css$/, loader: 'style!css!autoprefixer'}
      {test: /\.(eot|woff|woff2|ttf|svg)((\?|\#)[\?\#\w\d_-]+)?$/, loader: "url", query: {limit: 100, name: fontName}}
    ]
  plugins: [
    new webpack.optimize.CommonsChunkPlugin('vendor', 'vendor.js')
    new webpack.HotModuleReplacementPlugin()
  ]
