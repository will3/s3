module.exports = (app, scene) ->
	game = app.get 'game'
	panel = require './gui/gui-panel.coffee'
	panel
		blocks: app.get 'blocks'
		click: (type) ->
			game.blockType = type
	return