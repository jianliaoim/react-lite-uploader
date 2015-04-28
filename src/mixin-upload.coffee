
FileAPI = require 'fileapi'

module.exports =
  mockImage: (file, fileCategory) ->
    image = FileAPI.Image file
    image.preview 200, 200
    image.get (err, imageEL) =>
      src = imageEL.toDataURL()
      mocked =
        downloadUrl: src
        fileCategory: fileCategory
        fileKey: null
        fileName: file.name
        fileSize: file.size
        fileState: undefined
        fileType: file.type
        imageWidth: 0
        imageHeight: 0
        source: 'mock'
        thumbnailUrl: src
      @props.onThumbnail mocked

  uploadFile: (file) ->
    file.xhr = FileAPI.upload
      url: @props.url
      files:
        file: file
      fileupload: (file, xhr, options) =>
        fileCategory = file.type.split('/')[0]
        switch fileCategory
          when 'image' then @mockImage file, fileCategory
          else
            console.log 'fileupload', file, xhr, options
      fileprogress: (event, file, xhr, options) =>
        @props.onProgress (event.loaded / event.total)
      filecomplete: (err, xhr, file, options) =>
        try
          data = JSON.parse xhr.responseText
          @props.onSuccess data
        catch error
          @props.onError error
