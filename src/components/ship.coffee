class Ship
	constructor: (@app) ->

	start: () ->
		@blockModel = @app.getComponent @object, 'blockModel'

		if !@blockModel?
			throw new Error 'blockModel cannot be empty'

	tick: () ->
		return

module.exports = Ship