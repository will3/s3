class ShipControl
	@$inject: ['input', 'keyMap', 'app']

	constructor: (@input, @keyMap, @app) ->
		@ship = null
		@turnAccelerateAmount = 0.5
		@cooldown = null
		@sequentialFireInterval = 100

	start: () ->
		if @cooldown is null
			throw new Error 'cooldown cannot be empty'

		@cooldown.add 'sequential fire', @sequentialFireInterval

	tick: () ->
		if @ship == null
			return

		inputState = @input.state

		upAmount = 0
		rightAmount = 0

		if inputState.keyHold @keyMap.up
			upAmount++
		if inputState.keyHold @keyMap.down
			upAmount--
		if inputState.keyHold @keyMap.left
			rightAmount--
		if inputState.keyHold @keyMap.right
			rightAmount++

		@ship.bank rightAmount

		if rightAmount isnt 0 and upAmount is 0
			upAmount = @turnAccelerateAmount

		@ship.accelerate upAmount

		if @cooldown.ready 'sequential fire'
			if inputState.keyHold @keyMap.fire
				@ship.fireNext()
				@cooldown.refresh 'sequential fire'

module.exports = ShipControl