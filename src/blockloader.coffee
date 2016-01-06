chunkUtils = require './utils/chunkutils.coffee'

class BlockLoader
	load: (app, object, data, options = {}) ->
		center = options.center || false

		blockModel = app.getComponent object, 'blockModel'
		blockAttachments = app.getComponent object, 'blockAttachments'

		try
			blockModelData = data.blockModel
			blockModel.deserialize blockModelData if blockModelData?
			blockAttachmentsData = data.blockAttachments
			blockAttachments.deserialize blockAttachmentsData if blockAttachmentsData?
		catch ex
			console.log ex
			console.log 'failed to load model'

		if center
			ccw = chunkUtils.ccw blockModel.chunk
			blockModel.origin = ccw

module.exports = BlockLoader