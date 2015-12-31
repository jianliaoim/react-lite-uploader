
shortid = require 'shortid'

if typeof window isnt 'undefined'
  FileAPI = require 'fileapi'

module.exports =
  uploadFile: (file, props) ->
    fileId = shortid.generate()

    file.xhr = FileAPI.upload
      url: props.url
      headers: props.headers
      files:
        file: file
      fileupload: (file, xhr, options) =>
        props.onCreate file, fileId
      fileprogress: (event, file, xhr, options) =>
        props.onProgress event.loaded, event.total, fileId
      filecomplete: (err, xhr, file, options) =>
        try
          data = JSON.parse xhr.responseText
          props.onSuccess data, fileId
        catch error
          props.onError error, fileId

  handlePasteEvent: (event, props) ->
    clipboardData = event.clipboardData
    accept = props.accept.split(',')
    .map (extension) -> extension.slice(1)

    Array::forEach.call clipboardData.types, (type, i) =>
      if type is 'Files'
        matchFile = accept.some (extension) ->
          fileType = clipboardData.items[i].type
          fileType.indexOf(extension) >= 0
        if matchFile
          copiedName = 'copy-paste'
          # Blob to File http://stackoverflow.com/q/27159179/883571
          if window.File?
            file = new File [clipboardData.items[i].getAsFile()], copiedName
          else
            file = clipboardData.items[i].getAsFile()
            file.lastModifiedDate = new Date()
            file.name = copiedName
          @uploadFile file, props
