
React = require 'react'

UploadArea = React.createFactory require './upload-area'
UploadButton = React.createFactory require './upload-button'

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
