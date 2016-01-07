
shortid = require 'shortid'

if typeof window isnt 'undefined'
  FileAPI = require 'fileapi'

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
      files:
        file: file
      fileupload: (file, xhr, options) =>
        props.onCreate? file, fileId
      fileprogress: (event, file, xhr, options) =>
        props.onProgress? event.loaded, event.total, fileId
      filecomplete: (err, xhr, file, options) =>
        try
          data = JSON.parse xhr.responseText
          props.onSuccess data, fileId
        catch error
          props.onError {type: 'failed-upload', data: error}, fileId

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
      acceptTypes = props.accept.split(',').map (extension) -> extension.slice(1)
      allTypesOk = files.every (file) ->
        acceptTypes.some (extension) ->
          file.type.split('/').indexOf(extension) >= 0
      if (not allTypesOk)
        return props.onError type: 'invalid-type', data: 'Invalid file type'

    files.forEach (file) =>
      @uploadFile file, props
