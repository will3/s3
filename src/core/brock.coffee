THREE = require 'three'
Injector = require './injector.coffee'
class Brock
	constructor: () ->
		@_injector = new Injector()
		@_injector_prefab = new Injector()
		@_timeout = null
		@frameRate = 48.0
		@world = require('./world.coffee')()
		@systems = {}	
		@tic = require('tic')()
		
		Events = require './events.coffee'
		@events = new Events()

		@start()

	getComponents: (object) ->
		return @world.getComponents object

	getComponent: (object, type) ->
		return @world.getComponent object, type

	attach: (object, component) ->
		if typeof component is 'string'
			type = component
			component = @_injector.get(type)
			component._type = type
		component.object = object
		@world.attach object, component

		@events.emit 'attach', object, component

		return component

	dettach: (object, component) ->
		if component is undefined
			components = @world.getComponents object
			components = components.splice()
			for component in components
				@world.dettach object, component
				@events.emit 'dettach', object, component
			return

		@world.dettach object, component
		@events.emit 'dettach', object, component
		return

	addPrefab: (object, prefab) ->
		if typeof	prefab is 'string'
			prefab = @_injector_prefab.get prefab

		obj = prefab @
		object.add obj

		obj

	destroy: (object) ->
		@dettach object
		if object.parent?
			object.parent.remove object

	component: (type, arg) ->
		@_injector.service type, arg
		return

	system: (type, arg) ->
		@_injector.service type, arg, true

	value: (type, value) ->
		@_injector.value type, value
		return

	prefab: (type, arg) ->
		@_injector_prefab.value type, arg
		return

	use: (type, system) ->
		if system?
			@systems[type] = system
			@_injector.value type, system
		else
			system = @_injector.get type
			@systems[type] = system

		return

	get: (type) ->
		return @_injector.get type

	tick: (dt) ->
		for type, system of @systems
			if !system._started
				system.start() if system.start isnt undefined
				system._started = true
			system.tick(dt) if system.tick isnt undefined

		@world.traverse (c) =>
			if !c._started
				c.start() if c.start isnt undefined
				c._started = true

		@world.traverse (c) =>
			if !c._started
				c.start() if c.start isnt undefined
				c._started = true
			c.tick(dt) if c.tick isnt undefined

		@world.traverse (c) =>
			c.lateTick() if c.lateTick isnt undefined

		for type, system of @systems
			system.lateTick() if system.lateTick isnt undefined
		return

	start: () ->
		interval = () =>
			dt = 1000 / @frameRate
			@_timeout = setTimeout(interval, dt)
			@tic.tick(dt)
			@tick(dt)
		interval()

	interval: (fn, time) ->
		return @tic.interval(fn, time)

	timeout: (fn, time) ->
		return @tic.timeout(fn, time)

module.exports = () -> 
	new Brock()

module.exports.Events = require './events.coffee'