
React = require 'react'
FileAPI = require 'fileapi'
classnames = require 'classnames'

mixinUploadHandler = require './mixin-upload'

div = React.createFactory 'div'
input = React.createFactory 'input'
T = React.PropTypes

module.exports = React.createClass
  displayName: 'uploader-area'
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

  getDefaultProps: ->
    multiple: false
    accept: undefined

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
      @uploadFile file

  render: ->
    className = classnames 'uploader-area',
      'is-dropping': @state.isOver

    div className: className,
      @props.children
      if @state.isOver
        div className: 'drop-place'
