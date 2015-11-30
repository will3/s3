_ = require 'lodash'

class Injector
	constructor: () ->
		@bindings = {}

	factory: (type, factory) ->
		deps = []

		if factory.$inject?
			deps = factory.$inject
		else if _.isArray factory
			last = factory.pop()
			deps = factory
			factory = last

		@bindings[type] = 
			factory: factory
			deps: deps
		return

	value: (type, value) ->
		@bindings[type] = 
			value: value
		return

	service: (type, constructor) ->
		deps = []

		if constructor.$inject?
			deps = constructor.$inject
		else if _.isArray constructor
			last = constructor.pop()
			deps = constructor
			constructor = last

		@bindings[type] = 
			factory: () ->
				args = Array.prototype.slice.call arguments
				new(Function.prototype.bind.apply(
					constructor,
					[null].concat args
				))
			deps: deps
		return

	get: (type) ->
		binding = @bindings[type]

		if binding is undefined
			throw new Error 'binding not found for ' + type

		if binding.value isnt undefined
			return binding.value

		factory = binding.factory

		deps = binding.deps.map (t) =>
			@get(t)

		return factory.apply(null, deps)

module.exports = () ->
	new Injector()