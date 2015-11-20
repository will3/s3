_ = require 'lodash'
keycode = require 'keycode'

class Input
	constructor: (@element) ->
		@state = new InputState
		@listeners = {}

	start: () ->
		@element.addEventListener 'mousedown', @listeners.mousedown = (e) => 
			@state.mousedowns.push(e.button)
			return
		@element.addEventListener 'mouseup', @listeners.mouseup = (e) => 
			@state.mouseups.push(e.button)
			return
		@element.addEventListener 'mousemove', @listeners.mousemove = (e) => 
			@state.mouseX = e.clientX
			@state.mouseY = e.clientY
			return
		@element.addEventListener 'mouseenter', @listeners.mouseenter = () => 
			@state.mouseenter = true
			return
		@element.addEventListener 'mouseleave', @listeners.mouseleave = () => 
			@state.mouseleave = true
			return
		@element.addEventListener 'keydown', @listeners.keydown = (e) =>
			@state.keydowns.push keycode e
			return
		@element.addEventListener 'keyup', @listeners.keyup = (e) =>
			@state.keyups.push keycode e
			return
		return

	lateTick: () ->
		@state.clearTemporalStates()
		return

	dispose: () ->
		@element.removeEventListener 'mousedown', @listeners.mousedown
		@element.removeEventListener 'mouseup', @listeners.mouseup
		@element.removeEventListener 'mousemove', @listeners.mousemove
		@element.removeEventListener 'mouseenter', @listeners.mouseenter
		@element.removeEventListener 'mouseleave', @listeners.mouseleave
		@element.removeEventListener 'keydown', @listeners.keydown
		@element.removeEventListener 'keyup', @listeners.keyup
		return

class InputState
	constructor: () ->
		@mouseX = 0
		@mouseY = 0
		@mousedowns = []
		@mouseups = []
		@mouseenter = false
		@mouseleave = false
		@keydowns = []
		@keyups = []

	mouseDown: (button) ->
		return @mousedowns.length > 0 if button is undefined
		return _.includes @mousedowns, button

	mouseUp: (button) ->
		return @mouseups.length > 0 if button is undefined
		return _.includes @mouseups, button

	keyDown: (key) ->
		return _.includes @keydowns, key

	keyUp: (key) ->
		return _.includes @keyups, key

	clearTemporalStates: () ->
		@mousedowns = []
		@mouseups = []
		@mouseenter = false
		@mouseleave = false
		@keydowns = []
		@keyups = []
		return

module.exports = () ->
	args = Array.prototype.slice.call arguments
	new(Function.prototype.bind.apply(
		Input,
		[null].concat args
	))