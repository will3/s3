chunkUtils = require '../utils/chunkutils.coffee'

class Ship
	@$inject: ['app']

	constructor: (@app) ->
		@blockModel = null

	start: () ->
		@updateComponents()
		if !@blockModel?
			throw new Error 'blockModel cannot be empty'

	updateComponents: () ->
		@blockModel = @app.getComponent @object, 'blockModel'
		@engines = @app.getComponents @object, 'engine'

	tick: () ->
		return

	bank: (amount) ->
		# todo
		return

	accelerate: (amount) ->
		# todo
		return

module.exports = Ship