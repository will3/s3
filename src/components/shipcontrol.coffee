class ShipControl
	@$inject: ['input', 'keyMap', 'app']

	constructor: (@input, @keyMap, @app) ->
		@ship = null

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
		@ship.accelerate upAmount

module.exports = ShipControl