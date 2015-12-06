module.exports = (app) ->
	app.value 'keyMap', require './data/keymap.json'
	app.value 'blocks', require './data/blocks.json'
	app.value 'events', app.events

	app.component 'blockModel', require './components/blockmodel.coffee'
	app.component 'cameraController', ['input', 'keyMap', require './components/cameracontroller.coffee']
	app.component 'blockWireframe', require './components/blockwireframe.coffee'
	app.component 'asteroid', ['app', require './components/asteroid.coffee']
	app.component 'ship', require './components/ship.coffee'
	app.component 'gameComponent', require './components/game.coffee'
	app.component 'editor', require './components/editor.coffee'
	app.component 'engine', require './components/engine.coffee'
	app.component 'selectable', require './components/selectable.coffee'
	app.component 'shipControl', require './components/shipcontrol.coffee'

	app.system 'mouseovers', require './systems/mouseovers.coffee'
	app.system 'particleGroups', require './systems/particlegroups.coffee'

	app.use 'mouseovers'
	app.use 'particleGroups'