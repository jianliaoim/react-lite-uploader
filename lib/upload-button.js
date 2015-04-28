(function() {
  var FileAPI, React, T, div, input, mixinUploadHandler;

  React = require('react');

  FileAPI = require('fileapi');

  mixinUploadHandler = require('./mixin-upload');

  div = React.createFactory('div');

  input = React.createFactory('input');

  T = React.PropTypes;

  module.exports = React.createClass({
    displayName: 'uploader-button',
    mixins: [mixinUploadHandler],
    propTypes: {
      url: T.string.isRequired,
      accept: T.string,
      multiple: T.bool,
      onThumbnail: T.func,
      onProgress: T.func,
      onSuccess: T.func,
      onError: T.func
    },
    componentDidMount: function() {
      return this._inputEl = this.refs.input.getDOMNode();
    },
    getDefaultProps: function() {
      return {
        multiple: false,
        accept: void 0
      };
    },
    onChange: function(event) {
      var files;
      files = FileAPI.getFiles(event);
      return files.forEach((function(_this) {
        return function(file) {
          return _this.uploadFile(file);
        };
      })(this));
    },
    onClick: function() {
      return this._inputEl.click();
    },
    onInputClick: function(event) {
      return event.stopPropagation();
    },
    render: function() {
      return div({
        className: 'uploader-button',
        onClick: this.onClick
      }, this.props.children, input({
        className: 'file-input',
        onChange: this.onChange,
        ref: 'input',
        type: 'file',
        multiple: this.props.multiple,
        accept: this.props.accept,
        onClick: this.onInputClick
      }));
    }
  });

}).call(this);
