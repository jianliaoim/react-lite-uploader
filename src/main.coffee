
React = require 'react'

require './app/uploader-button.css'
require './app/uploader-area.css'
require './demo.css'

App = React.createFactory require './app/page'

React.render App(), document.querySelector('.demo')
