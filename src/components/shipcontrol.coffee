Keyboard = {
	Player1: 0
	Player2: 1
}

Cooldown = require '../cooldown.coffee'

class ShipControl
	@$inject: ['input', 'keyMap', 'app']

	constructor: (@input, @keyMap, @app) ->
		@ship = null
		@turnAccelerateAmount = 1.0
		@cooldown = new Cooldown()
		@sequentialFireInterval = 100
		@keyboard = Keyboard.Player1

	start: () ->
		@cooldown.add 'sequential fire', @sequentialFireInterval
		@updateKeyboard()

	updateKeyboard: () ->
		if @keyboard is Keyboard.Player1
			@key_up = @keyMap.up
			@key_down = @keyMap.down
			@key_left = @keyMap.left
			@key_right = @keyMap.right
			@key_fire = @keyMap.fire
		else
			@key_up = @keyMap.up2
			@key_down = @keyMap.down2
			@key_left = @keyMap.left2
			@key_right = @keyMap.right2
			@key_fire = @keyMap.fire2

	tick: () ->
		if @ship == null
			return

		@cooldown.tick()

		inputState = @input.state

		upAmount = 0
		rightAmount = 0

		if inputState.keyHold @key_up
			upAmount++
		if inputState.keyHold @key_down
			upAmount--
		if inputState.keyHold @key_left
			rightAmount--
		if inputState.keyHold @key_right
			rightAmount++

		@ship.bank rightAmount

		if rightAmount isnt 0 and upAmount is 0
			upAmount = @turnAccelerateAmount

		@ship.accelerate upAmount

		if @cooldown.ready 'sequential fire'
			if inputState.keyHold @key_fire
				@ship.fireNext()
				@cooldown.refresh 'sequential fire'

ShipControl.Keyboard = Keyboard
module.exports = ShipControl
