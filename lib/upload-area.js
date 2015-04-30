(function() {
  var FileAPI, React, T, classnames, div, input, mixinUploadHandler;

  React = require('react');

  FileAPI = require('fileapi');

  classnames = require('classnames');

  mixinUploadHandler = require('./mixin-upload');

  div = React.createFactory('div');

  input = React.createFactory('input');

  T = React.PropTypes;

  module.exports = React.createClass({
    displayName: 'uploader-area',
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
    getDefaultProps: function() {
      return {
        multiple: false,
        accept: void 0
      };
    },
    getInitialState: function() {
      return {
        isOver: false
      };
    },
    componentDidMount: function() {
      this._rootEl = this.getDOMNode();
      return this.initFileListener();
    },
    initFileListener: function() {
      return FileAPI.event.dnd(this._rootEl, this.onIsHover, this.onFilesLoad);
    },
    onIsHover: function(isOver) {
      return this.setState({
        isOver: isOver
      });
    },
    onFilesLoad: function(files) {
      return files.forEach((function(_this) {
        return function(file) {
          return _this.uploadFile(file);
        };
      })(this));
    },
    render: function() {
      var className;
      className = classnames('uploader-area', {
        'is-dropping': this.state.isOver
      });
      return div({
        className: className
      }, this.props.children, this.state.isOver ? div({
        className: 'drop-place'
      }) : void 0);
    }
  });

}).call(this);
