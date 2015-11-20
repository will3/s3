THREE = require 'three'

class Brock
	constructor: () ->
		@_injector = require('./injector.coffee')()
		@_timeout = null
		@frameRate = 48.0
		@world = require('./world.coffee')()
		@systems = {}	
		@start()

	attach: (object, component) ->
		if typeof component is 'string'
			component = @_injector.get(component)
		component.object = object
		@world.attach object, component
		return component

	dettach: (object, component) ->
		@world.attach object, component
		return

	component: (type, arg) ->
		@_injector.service type, arg
		return

	value: (type, value) ->
		@_injector.value type, value
		return

	use: (type, system) ->
		@systems[type] = system
		@_injector.value type, system
		return

	tick: () ->
		for type, system of @systems
			if !system._started
				system.start() if system.start isnt undefined
				system._started = true
			system.tick() if system.tick isnt undefined

		@world.traverse (c) =>
			if !c._started
				c.start() if c.start isnt undefined
				c._started = true
			c.tick() if c.tick isnt undefined

		@world.traverse (c) =>
			c.lateTick() if c.lateTick isnt undefined

		for type, system of @systems
			system.lateTick() if system.lateTick isnt undefined
		return

	start: () ->
		interval = () =>
			@_timeout = setTimeout(interval, 1000 / @frameRate)
			@tick()
		interval()

module.exports = () -> 
	new Brock()