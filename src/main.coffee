
React = require 'react'

require './demo.css'

App = React.createFactory require './app/page'

React.render App(), document.querySelector('.demo')
