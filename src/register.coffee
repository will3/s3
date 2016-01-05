module.exports = (app) ->
	# values
	app.value 'keyMap', require './data/keymap.json'
	app.value 'blocks', require './data/blocks.json'
	app.value 'events', app.events
	app.value 'geometries', {}
	app.value 'materials', {}
	app.value 'textures', require './textures.coffee'

	# components
	app.component 'blockModel', require './components/blockmodel.coffee'
	app.component 'cameraController', ['input', 'keyMap', require './components/cameracontroller.coffee']
	app.component 'asteroid', ['app', require './components/asteroid.coffee']
	app.component 'ship', require './components/ship.coffee'
	app.component 'editor', require './components/editor.coffee'
	app.component 'engine', require './components/engine.coffee'
	app.component 'selectable', require './components/selectable.coffee'
	app.component 'shipControl', require './components/shipcontrol.coffee'
	app.component 'blockMesher', require './components/blockmesher.coffee'
	app.component 'grid', require './components/grid.coffee'
	app.component 'blockPreview', require './components/blockpreview.coffee'
	app.component 'rigidBody', require './components/rigidbody.coffee'
	app.component 'blockAttachments', require './components/blockattachments.coffee'
	app.component 'laser', require './components/laser.coffee'
	app.component 'laserAmmo', require './components/laserammo.coffee'
	app.component 'selfDestruct', require './components/selfdestruct.coffee'
	app.component 'cooldown', require './components/cooldown.coffee'
	app.component 'lineSprite', require './components/linesprite.coffee'
	
	# systems
	app.system 'particleGroups', require './systems/particlegroups.coffee'
	app.system 'collision', require './systems/collision.coffee'

	app.use 'particleGroups'
	app.use 'collision'

	# prefabs
	app.prefab 'asteroid', require './prefabs/p_asteroid.coffee'
	app.prefab 'editor', require './prefabs/p_editor.coffee'
	app.prefab 'ship', require './prefabs/p_ship.coffee'
	app.prefab 'laserAmmo', require './prefabs/p_laserAmmo.coffee'
	app.prefab 'laser', require './prefabs/p_laser.coffee'
	app.prefab 'engine', require './prefabs/p_engine.coffee'