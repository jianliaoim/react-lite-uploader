(function() {
  var FileAPI;

  FileAPI = require('fileapi');

  module.exports = {
    mockImage: function(file, fileCategory) {
      var image;
      image = FileAPI.Image(file);
      image.preview(200, 200);
      return image.get((function(_this) {
        return function(err, imageEL) {
          var mocked, src;
          src = imageEL.toDataURL();
          mocked = {
            downloadUrl: src,
            fileCategory: fileCategory,
            fileKey: null,
            fileName: file.name,
            fileSize: file.size,
            fileState: void 0,
            fileType: file.type,
            imageWidth: 0,
            imageHeight: 0,
            source: 'mock',
            thumbnailUrl: src
          };
          return _this.props.onThumbnail(mocked);
        };
      })(this));
    },
    uploadFile: function(file) {
      return file.xhr = FileAPI.upload({
        url: this.props.url,
        files: {
          file: file
        },
        fileupload: (function(_this) {
          return function(file, xhr, options) {
            var fileCategory;
            fileCategory = file.type.split('/')[0];
            switch (fileCategory) {
              case 'image':
                return _this.mockImage(file, fileCategory);
              default:
                return console.log('fileupload', file, xhr, options);
            }
          };
        })(this),
        fileprogress: (function(_this) {
          return function(event, file, xhr, options) {
            return _this.props.onProgress(event.loaded / event.total);
          };
        })(this),
        filecomplete: (function(_this) {
          return function(err, xhr, file, options) {
            var data, error;
            try {
              data = JSON.parse(xhr.responseText);
              return _this.props.onSuccess(data);
            } catch (_error) {
              error = _error;
              return _this.props.onError(error);
            }
          };
        })(this)
      });
    }
  };

}).call(this);
