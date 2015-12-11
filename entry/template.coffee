
stir = require 'stir-template'
React = require 'react'
config = require 'config'

assetLinks = require '../packing/asset-links'

Page = React.createFactory require '../src/app/page'

{html, head, title, body, meta, script, link, div, a, span} = stir

module.exports = ->

  stir.render stir.doctype(),
    html null,
      head null,
        title null, "React Lite Uploader"
        meta charset: 'utf-8'
        link rel: 'icon', href: 'http://tp4.sinaimg.cn/5592259015/180/5725970590/1'
        if assetLinks.style?
          link rel: 'stylesheet', href: assetLinks.style
        script null, "window._initialStore = (#{JSON.stringify(config)})"
        script src: assetLinks.vendor, defer: true
        script src: assetLinks.main, defer: true
      body null,
        div class: 'intro',
          div class: 'title', "Demo of Uploader"
          div null,
            span null, "Read more at "
            a href: 'http://github.com/teambition/react-lite-uploader',
              'github.com/teambition/react-lite-uploader'
            span null, '.'
        div null, 'In the demo below we need a token, which may be expired...'
        div class: 'demo',
          React.renderToString Page()
