module.exports = (app, scene) ->
	app.attach scene, 'gui-panel'

	# require('./gui/panel.coffee')(
	# 	blocks: blocks
	# 	events: events
	# 	click: (type) ->
	# 		console.log type
	# )