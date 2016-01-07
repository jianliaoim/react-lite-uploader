
React = require 'react'

if typeof window isnt 'undefined'
  FileAPI = require 'fileapi'

UploadArea = React.createFactory require './upload-area'
UploadButton = React.createFactory require './upload-button'
uploadUtil = require '../upload-util'

{div, img, span, br, textarea} = React.DOM

if typeof window is 'undefined'
  config = require '../../config/default'
else
  config = window._initialStore

module.exports = React.createClass
  getInitialState: ->
    image: null

  componentDidMount: ->
    uploadUtil.handleFileDropping @refs.text.getDOMNode(),
      url: config.uploadUrl
      headers:
        authorization: config.token
      accept: ".gif,.jpg,.jpeg,.bmp,.png"
      multiple: false
      onCreate: @onCreate
      onProgress: @onProgress
      onSuccess: @onSuccess
      onError: @onError

  onCreate: (file, fileId) ->
    console.log('onCreate:', file, fileId)
    image = FileAPI.Image file
    image.preview 200, 200
    image.get (err, imageEL) =>
      if err
        console.error 'err', err
      else
        @setState image: imageEL.toDataURL()

  onSuccess: (data, fileId) ->
    console.log('onSuccess:', data, fileId)

  onProgress: (loaded, total, fileId) ->
    console.log('onProgress:', loaded, total, fileId)

  onError: (data, fileId) ->
    console.error('onError:', data, fileId)

  onPaste: (event) ->
    uploadUtil.handlePasteEvent event.nativeEvent,
      url: config.uploadUrl
      headers:
        authorization: config.token
      accept: ".gif,.jpg,.jpeg,.bmp,.png"
      multiple: false
      onCreate: this.onCreate
      onProgress: this.onProgress
      onSuccess: this.onSuccess
      onError: this.onError

  renderButton: ->
    UploadButton
      url: config.uploadUrl
      headers:
        authorization: config.token
      accept: ".gif,.jpg,.jpeg,.bmp,.png"
      multiple: false
      onCreate: this.onCreate
      onProgress: this.onProgress
      onSuccess: this.onSuccess
      onError: this.onError
      span className="trigger", 'click to upload'

  renderArea: ->
    UploadArea
      url: config.uploadUrl
      headers:
        authorization: config.token
      accept: ".gif,.jpg,.jpeg,.bmp,.png"
      multiple: false
      onCreate: this.onCreate
      onProgress: this.onProgress
      onSuccess: this.onSuccess
      onError: this.onError
      div className: "target", "Drop file here"

  render: ->
    div null,
      div className: "demo",
        div null, 'Drop file only'
        this.renderArea()
      div className: "demo",
        span null, 'Click only: '
        this.renderButton()
        br()
        if this.state.image
          img src: this.state.image
      div className: 'demo',
        textarea ref: 'text', onPaste: @onPaste, placeholder: 'Drop or Paste'
      div className: 'demo',
        div className: 'note', "Open console find details..."
