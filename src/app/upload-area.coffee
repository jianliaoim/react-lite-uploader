
React = require 'react'
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
    onSuccess: T.func
    onError: T.func
    # children

  getDefaultProps: ->
    multiple: false
    accept: undefined
    onProgress: ->

  getInitialState: ->
    isOver: false

  componentDidMount: ->
    @_rootEl = @getDOMNode()
    @initFileListener()

  initFileListener: ->
    FileAPI.event.dnd @_rootEl, @onIsHover, @onFilesLoad

  onIsHover: (isOver) ->
    @setState isOver: isOver

  onFilesLoad: (files) ->
    files.forEach (file) =>
      uploadUtil.uploadFile file, @props

  onPaste: (event) ->
    uploadUtil.handlePasteEvent event, @props

  render: ->
    className = classnames 'uploader-area',
      'is-dropping': @state.isOver

    div className: className, onPaste: @onPaste, tabIndex: 0,
      @props.children
      if @state.isOver
        div className: 'drop-place'
