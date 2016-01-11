
React = require 'react'
assign = require 'object-assign'
classnames = require 'classnames'

if typeof window isnt 'undefined'
  FileAPI = require 'fileapi'

uploadUtil = require '../upload-util'

div = React.createFactory 'div'
input = React.createFactory 'input'
T = React.PropTypes

module.exports = React.createClass
  displayName: 'uploader-area'

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

  getDefaultProps: ->
    multiple: false
    accept: ''

  getInitialState: ->
    isOver: false

  componentDidMount: ->
    @_rootEl = @getDOMNode()
    @initFileListener()

  initFileListener: ->
    uploadUtil.handleFileDropping @_rootEl,
      assign onFileHover: @onIsHover, @props

  onIsHover: (isOver) ->
    @setState isOver: isOver

  onPaste: (event) ->
    uploadUtil.handlePasteEvent event.nativeEvent, @props

  render: ->
    className = classnames 'uploader-area',
      'is-dropping': @state.isOver

    div className: className, onPaste: @onPaste, tabIndex: 0,
      @props.children
      if @state.isOver
        div className: 'drop-place'
