class GameController 
	@$inject: ['input', 'keyMap']

	constructor: (@input, @keyMap) ->

	start: () ->

	tick: () ->
		inputState = @input.state
		if inputState.keyUp @keyMap.restart
			# todo
			
module.exports = GameController