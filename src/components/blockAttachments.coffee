coordUtils = require '../utils/coordutils.coffee'
Events = require('../core/brock.coffee').Events
_ = require 'lodash'

class BlockAttachments
	@$inject: ['app']

	constructor: (@app) ->
		@attachments = []
		@events = new Events()

	start: () ->
		if @blockModel is null
			throw new Error 'blockModel cannot be empty'

	getAttachments: (coord) ->
		return _.filter @attachments, (attachment) ->
			attachment.coord.equals coord

	addAttachment: (coord, type) ->
		point = coordUtils.coordToPoint coord, @blockModel

		objAttachment = @app.addPrefab @blockModel.objModel, type
		objAttachment.position.copy point

		@attachments.push
			object: objAttachment
			coord: coord
			type: type

		event = 
			coord: coord
			type: type
		@events.emit 'add', event

	removeAttachments: (coord) ->
		attachments = @getAttachments coord
		
		for attachment in attachments
			@app.destroy attachment.object

		@attachments = _.filter @attachments, (attachment) ->
			!attachment.coord.equals coord

		event =
			coord: coord

		@events.emit 'remove', event

	serialize: () ->
		body = []
		for attachment in @attachments
			body.push
				coord: attachment.coord
				type: attachment.type

		return body

	deserialize: (body) ->
		for attachment in body
			coord = new THREE.Vector3().copy attachment.coord
			@addAttachment coord, attachment.type

		return @

module.exports = BlockAttachments