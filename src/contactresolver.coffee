chunkUtils = require './utils/chunkutils.coffee'

module.exports = (app) ->
	resolver = (a, b) ->
		blockModelA = app.getComponent a, 'blockModel'
		blockModelB = app.getComponent b, 'blockModel'

		radiusA = a.radius
		radiusB = b.radius

		if blockModelA? and not blockModelB


	return resolver

module.exports = (a, b) ->

	# if rigidBodyi? and rigidBodyj?
	# 	rigidBodyi.events.emit 'collision', rigidBodyj
	# 	rigidBodyj.events.emit 'collision', rigidBodyi

			# damage = @app.getComponent b.object, 'damage'
			# if damage?
			# 	if @damagable.by damage
			# 		point = b.object.position
			# 		localPoint = @object.worldToLocal point
			# 		coord = coordUtils.pointToCoord localPoint, @blockModel

			# 		if damageUtils.shouldApplyDamage @app, @object, coord, damage
			# 			damageUtils.applyDamage @app, @object, coord, damage
			# 			@app.destroy b.object