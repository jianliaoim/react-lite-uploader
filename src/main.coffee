
React = require 'react'

require './demo.css'

render = ->
  App = React.createFactory require './app/page'
  React.render App(), document.querySelector('.demo')

render()

if module.hot
  module.hot.accept './app/page', ->
    render()
