
fs = require('fs')
path = require 'path'
webpack = require('webpack')
SkipPlugin = require 'skip-webpack-plugin'
ExtractTextPlugin = require 'extract-text-webpack-plugin'

webpackDev = require('./webpack-dev')

fontName = 'fonts/[name].[ext]'

module.exports = (info) ->
  webpackConfig = webpackDev info
  publicPath = ''

  # return
  entry:
    vendor: []
    main: ['./src/main']
  output:
    path: path.join info.__dirname, 'build/'
    filename: '[name].[chunkhash:8].js'
    publicPath: publicPath
  resolve: webpackConfig.resolve
  module:
    loaders: [
      {test: /\.coffee$/, loader: 'coffee'}
      {test: /\.less$/, loader: 'style!css!less'}
      {test: /\.css$/, loader: ExtractTextPlugin.extract('style-loader', 'css!autoprefixer')}
      {test: /\.(eot|woff|woff2|ttf|svg)((\?|\#)[\?\#\w\d_-]+)?$/, loader: "url", query: {limit: 100, name: fontName}}
    ]
  plugins: [
    new webpack.optimize.CommonsChunkPlugin('vendor', 'vendor.[chunkhash:8].js')
    if info.isMinified
      new webpack.optimize.UglifyJsPlugin(compress: {warnings: false}, sourceMap: false)
    else
      new SkipPlugin info: 'UglifyJsPlugin skipped'
    new ExtractTextPlugin("style.[chunkhash:8].css")
  ]
