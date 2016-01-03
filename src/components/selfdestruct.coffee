class SelfDestruct
	@$inject: ['app']

	constructor: (@app) ->
		@life = 1000
		@count = 0

	start: () ->
		# start count down
		@count = @life

	tick: (dt) ->
		@count -= dt

		if @count <= 0
			@app.destroy @object

module.exports = SelfDestruct