module.exports = (editor) ->
	menu = 
		'none': () ->
			editor.component = null
		'engine': () ->
			editor.component = 'engine'
		'laser': () ->
			editor.component = 'laser'
		'undo': () ->
			editor.undo()
		'redo': () ->
			editor.redo()
		'undo all': () ->
			editor.undoall()
		'redo all': () ->
			editor.redoall()
		'clear': () ->
			editor.clear()
		'leave dock': () ->
			editor.toggleEdit()
		'print': () ->
			alert JSON.stringify editor.data()

	gui = new dat.GUI()

	history = gui.addFolder 'history'
	history.add menu, 'undo'
	history.add menu, 'redo'
	history.add menu, 'undo all'
	history.add menu, 'redo all'
	history.add menu, 'clear'

	components = gui.addFolder 'components'
	components.add menu, 'none'
	components.add menu, 'engine'
	components.add menu, 'laser'

	gui.add menu, 'leave dock'

	debug = gui.addFolder 'debug'
	debug.add menu, 'print'

	history.open()
	components.open()
	debug.open()