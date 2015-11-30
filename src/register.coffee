module.exports = (app) ->
	app.value 'keyMap', require './data/keymap.json'
	app.value 'blocks', require './data/blocks.json'
	app.value 'events', require './systems/events.coffee'

	app.component 'blockModel', require './components/blockmodel.coffee'
	app.component 'cameraController', ['input', 'keyMap', require './components/cameracontroller.coffee']
	app.component 'editor', require './components/editor.coffee'
	app.component 'blockWireframe', require './components/blockwireframe.coffee'
	app.component 'asteroid', ['app', require './components/asteroid.coffee']
	app.component 'ship', ['app', require './components/ship.coffee']
	app.component 'gui-panel', ['blocks', 'events', require './components/gui-panel.coffee']
	app.component 'game', require './components/game.coffee'