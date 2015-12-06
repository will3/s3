chunkUtils = require './chunkutils.coffee'

module.exports =
	recenter: (blockModel) ->
		ccg = chunkUtils.getCcg blockModel.chunk