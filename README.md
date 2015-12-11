
React Lite Uploader
----

> This project is no mature, do not use it in production!

Uploader component from Talk by Teambition.

Demo http://ui.talk.ai/react-lite-uploader

Based on the work of https://github.com/mailru/FileAPI

### Supposition

Contains internal business logic defined at Talk by Teambition.

### Usage

```bash
npm i --save react-lite-uploader
```

A small demo of uploaders:

```coffee
React = require 'react'

liteUploader = require 'react-lite-uploader'

UploadArea = React.createFactory liteUploader.Area
UploadButton = React.createFactory liteUploader.Button

{div, img, span, br} = React.DOM

if typeof window is 'undefined'
  config = require '../../config/default'
else
  config = window._initialStore

module.exports = React.createClass
  getInitialState: ->
    image: null

  onThumbnail: (data) ->
    console.log('onThumbnail:', data)
    this.setState image: data.downloadUrl

  onSuccess: (data) ->
    console.log('onSuccess:', data)

  onProgress: (data) ->
    console.log('onProgress:', data)

  onError: (data) ->
    console.log('onError:', data)
    alert('file server is not finished yet..')

  renderButton: ->
    UploadButton
      url: config.uploadUrl
      headers:
        authorization: config.token
      acceptedFiles: ".gif,.jpg,.jpeg,.bmp,.png"
      multiple: false
      onThumbnail: this.onThumbnail
      onProgress: this.onProgress
      onSuccess: this.onSuccess
      onError: this.onError
      span className="trigger", 'click to upload'

  renderArea: ->
    UploadArea
      url: config.uploadUrl
      headers:
        authorization: config.token
      acceptedFiles: ".gif,.jpg,.jpeg,.bmp,.png"
      multiple: false
      onThumbnail: this.onThumbnail
      onProgress: this.onProgress
      onSuccess: this.onSuccess
      onError: this.onError
      div className="target", "Drop file here"

  render: ->
    div null,
      div className: "demo",
        div null, 'Drop file only'
        this.renderArea()
      div className: "demo",
        span null, 'Click only '
        this.renderButton()
        br()
        if this.state.image
          img src: this.state.image

        div className: 'note', "Open console find details..."
```

### Develop

Based on Jianliao's project template:

https://github.com/teambition/coffee-webpack-starter

### License

MIT
