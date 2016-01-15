
React = require 'react'

if typeof window isnt 'undefined'
  FileAPI = require 'fileapi'

uploadUtil = require '../upload-util'

div = React.createFactory 'div'
input = React.createFactory 'input'
T = React.PropTypes

module.exports = React.createClass
  displayName: 'uploader-button'

  propTypes:
    url: T.string.isRequired
    headers: T.object
    accept: T.string
    multiple: T.bool
    onCreate: T.func
    onProgress: T.func
    onSuccess: T.func.isRequired
    onError: T.func.isRequired
    # children

  componentDidMount: ->
    @_inputEl = @refs.input.getDOMNode()

  getDefaultProps: ->
    multiple: false
    accept: ''

  onSuccess: (args...) ->
    @_inputEl.value = null
    @props.onSuccess args...

  onError: (args...) ->
    @_inputEl.value = null
    @props.onError args...

  onChange: (event) ->
    files = FileAPI.getFiles event
    props =
      url: @props.url
      headers: @props.headers
      accept: @props.accept
      multiple: @props.multiple
      onCreate: @props.onCreate
      onProgress: @props.onProgress
      onSuccess: @onSuccess
      onError: @onError
    uploadUtil.onFilesLoad files, props

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
