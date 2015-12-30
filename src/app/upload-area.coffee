
React = require 'react'
classnames = require 'classnames'

if typeof window isnt 'undefined'
  FileAPI = require 'fileapi'

mixinUploadHandler = require '../mixin/upload'

div = React.createFactory 'div'
input = React.createFactory 'input'
T = React.PropTypes

module.exports = React.createClass
  displayName: 'uploader-area'
  mixins: [mixinUploadHandler]

  propTypes:
    url: T.string.isRequired
    headers: T.object
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
      @uploadFile file

  onPaste: (event) ->
    clipboardData = event.clipboardData
    accept = @props.accept.split(',')
    .map (extension) -> extension.slice(1)

    Array::forEach.call clipboardData.types, (type, i) =>
      if type is 'Files'
        matchFile = accept.some (extension) ->
          fileType = clipboardData.items[i].type
          fileType.indexOf(extension) >= 0
        if matchFile
          pastedFileName = 'pasted'
          # Blob to File http://stackoverflow.com/q/27159179/883571
          if window.File?
            file = new File [clipboardData.items[i].getAsFile()], pastedFileName
          else
            file = clipboardData.items[i].getAsFile()
            file.lastModifiedDate = new Date()
            file.name = pastedFileName
          @uploadFile file

  render: ->
    className = classnames 'uploader-area',
      'is-dropping': @state.isOver

    div className: className, onPaste: @onPaste, tabIndex: 0,
      @props.children
      if @state.isOver
        div className: 'drop-place'
