
React = require 'react'
FileAPI = require 'fileapi'

mixinUploadHandler = require './mixin-upload'

div = React.createFactory 'div'
input = React.createFactory 'input'
T = React.PropTypes

module.exports = React.createClass
  displayName: 'uploader-button'
  mixins: [mixinUploadHandler]

  propTypes:
    url: T.string.isRequired
    accept: T.string
    multiple: T.bool
    onThumbnail: T.func
    onProgress: T.func
    onSuccess: T.func
    onError: T.func
    # children

  componentDidMount: ->
    @_inputEl = @refs.input.getDOMNode()

  getDefaultProps: ->
    multiple: false
    accept: undefined

  onChange: (event) ->
    files = FileAPI.getFiles event
    files.forEach (file) =>
      @uploadFile file

  onClick: ->
    @_inputEl.click()

  onInputClick: (event) ->
    # don't trigger @onClick by itself
    event.stopPropagation()

  render: ->
    div className: 'uploader-button', onClick: @onClick,
      @props.children
      input
        className: 'file-input', onChange: @onChange, ref: 'input'
        type: 'file', multiple: @props.multiple,
        accept: @props.accept, onClick: @onInputClick

