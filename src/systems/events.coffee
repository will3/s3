_ = require 'lodash'

events = 
	listeners: {}
	on: (event, callback) ->
		if !@listeners[event]?
			@listeners[event] = []
		@listeners[event].push callback

	emit: (event) ->
		callbacks = @listeners[event] || []
		args = Array.prototype.slice.call arguments
		callbacks.forEach (callback) ->
			callback.apply null, args.slice(1)

	removeListener: (event, callback) ->
		if @listeners[event]?
			_.pull @listeners[event], callback

		if callback is undefined
			@listeners[event] = []

module.exports = events