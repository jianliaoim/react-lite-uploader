
import {default as UploadArea} from './upload-area'
import {default as UploadButton} from './upload-button'
import {default as React} from 'react'

import './uploader-button.css'
import './uploader-area.css'
import './demo.css'

var App = React.createClass({
  getInitialState: function() {
    return {
      image: null,
    }
  },
  onThumbnail: function(data) {
    console.log('onThumbnail:', data)
    this.setState({image: data.downloadUrl})
  },
  onSuccess: function(data) {
    console.log('onSuccess:', data)
  },
  onProgress: function(data) {
    console.log('onProgress:', data)
  },
  onError: function(data) {
    console.log('onError:', data)
    alert('file server is not finished yet..')
  },
  renderButton: function() {
    return <UploadButton
      url="/"
      acceptedFiles=".gif,.jpg,.jpeg,.bmp,.png"
      multiple={false}
      onThumbnail={this.onThumbnail}
      onProgress={this.onProgress}
      onSuccess={this.onSuccess}
      onError={this.onError}>
      <div className="trigger">
      {'click to upload'}
      </div>
      </UploadButton>
  },
  renderArea: function() {
    return <UploadArea
      url="/"
      acceptedFiles=".gif,.jpg,.jpeg,.bmp,.png"
      multiple={false}
      onThumbnail={this.onThumbnail}
      onProgress={this.onProgress}
      onSuccess={this.onSuccess}
      onError={this.onError}>
      <div className="target">{"drop here"}</div>
      </UploadArea>
  },
  render: function() {
    return <div className="demo">
      <div>{'area'}</div>
      {this.renderArea()}
      <div>{'button'}</div>
      {this.renderButton()}
      <br/>
      {(this.state.image) ?
        <img src={this.state.image}/> : undefined
      }
    </div>
  }
})

var demo = document.querySelector('.demo')

React.render(<App/>, demo)
