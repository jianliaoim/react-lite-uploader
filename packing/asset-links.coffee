
config = require 'config'

if config.env is 'dev'
  module.exports =
    main: "http://localhost:#{config.webpackDevPort}/main.js"
    vendor: "http://localhost:#{config.webpackDevPort}/vendor.js"
    style: null
else
  assets = require '../packing/assets'
  prefix = ''

  module.exports =
    main: "#{prefix}#{assets.main[0]}"
    style: "#{prefix}#{assets.main[1]}"
    vendor: "#{prefix}#{assets.vendor}"
