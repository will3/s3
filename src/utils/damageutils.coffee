chunkUtils = require './chunkutils.coffee'

module.exports =
	applyDamage: (app, obj, coord, damage) ->
		blockModel = app.getComponent obj, 'blockModel'
		blockAttachments = app.getComponent obj, 'blockAttachments'

		damageTable = damage.damageTable
		radius = damageTable.length

		callback = (x, y, z, obj, dis) ->
			amount = damageTable[dis] || 0
			return if amount is 0
			return if not obj?
			amount /= obj.touchness
			obj.integrity -= amount
			obj.integrity = 0 if obj.integrity < 0

			if obj.integrity is 0
				blockAttachments.removeAttachments x: x, y: y, z: z

			blockModel.update x, y, z

		chunkUtils.visitAround blockModel.chunk, coord, radius, callback

		return