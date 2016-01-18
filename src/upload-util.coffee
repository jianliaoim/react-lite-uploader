
shortid = require 'shortid'

if typeof window isnt 'undefined'
  FileAPI = require 'fileapi'
  gloablInputButton = document.createElement 'input'
  gloablInputButton.type = 'file'

checkDefaultProps = (props) ->
  if not props.accept?
    props.accept = ''
  if not props.multiple?
    props.multiple = false
  props

module.exports =
  uploadFile: (file, props) ->
    fileId = shortid.generate()

    file.xhr = FileAPI.upload
      url: props.url
      headers: props.headers
      data:
        size: file.size
      files:
        file: file
      fileupload: (file, xhr, options) =>
        props.onCreate? file, fileId
      fileprogress: (event, file, xhr, options) =>
        props.onProgress? event.loaded, event.total, fileId
      filecomplete: (err, xhr, file, options) =>
        # err is a boolean, strange style from fileapi, be cautious!
        if err
          errorDetails =
            type: 'failed-upload', data: err
            xhr: xhr, file: file, options: options
          props.onError errorDetails, fileId
        else
          data = null
          isDataParsed = false
          try
            data = JSON.parse xhr.responseText
            isDataParsed = true
          catch error
            errorDetails =
              type: 'failed-parsing-result', data: error
              xhr: xhr, file: file, options: options
            props.onError errorDetails, fileId
          if isDataParsed
            props.onSuccess data, fileId

  handlePasteEvent: (event, props) ->
    clipboardData = event.clipboardData

    maybeFiles = Array::map.call clipboardData.types, (type, i) =>
      if type is 'Files'
        fileType = clipboardData.items[i].type
        copiedName = 'copy-paste'
        # Blob to File http://stackoverflow.com/q/27159179/883571
        if window.File?
          fileBlob = clipboardData.items[i].getAsFile()
          file = new File [fileBlob], copiedName, type: fileType
        else
          file = clipboardData.items[i].getAsFile()
          file.lastModifiedDate = new Date()
          file.name = copiedName
        file
      else null
    maybeFiles = maybeFiles.filter (file) -> file?
    if maybeFiles.length > 0
      event.preventDefault()
      @onFilesLoad maybeFiles, props

  handleFileDropping: (target, props) ->
    onFilesLoad = (files) => @onFilesLoad files, props
    onFileHover = (isHover) -> props.onFileHover? isHover
    FileAPI.event.dnd target, onFileHover, onFilesLoad

  onFilesLoad: (files, props) ->
    props = checkDefaultProps props
    # throw error if no file is available
    if files.length is 0
      return props.onError type: 'no-file', data: 'No file available'
    # throw error if too many files are selected
    if (not props.multiple) and files.length > 1
      return props.onError type: 'too-many-files', data: 'Too many files selected'
    # throw error if accepted types is not satisfied
    if props.accept.trim().length > 0
      acceptTypes = props.accept.split(',').map (extension) ->
        if extension[0] is '.'
          extension.slice(1)
        else extension
      allTypesOk = files.every (file) ->
        acceptTypes.some (extension) ->
          file.type.split('/').indexOf(extension) >= 0
      if (not allTypesOk)
        return props.onError type: 'invalid-type', data: 'Invalid file type'

    files.forEach (file) =>
      @uploadFile file, props

  handleInputChange: (event, props) ->
    files = FileAPI.getFiles event
    @onFilesLoad files, props

  handleClick: (props) ->
    gloablInputButton.multiple = props.multiple
    gloablInputButton.accept = props.accept
    gloablInputButton.click()
    gloablInputButton.onchange = (event) =>
      # rewrite method to inject null value
      oldOnSuccess = props.onSuccess
      oldOnError = props.onError
      props.onSuccess = (args...) ->
        oldOnSuccess args...
        gloablInputButton.value = null
      props.onError = (args...) ->
        oldOnError args...
        gloablInputButton.value = null

      @handleInputChange event, props
