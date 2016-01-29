hitTests = require './utils/hittests.coffee'
CollisionGroups = require './collisiongroups.coffee'
coordUtils = require './utils/coordutils.coffee'

# rigidBody.body.collisionFilterGroup = CollisionGroups.Ammo
module.exports = (app) ->
	contactForceAmount = 3000
	rigidBodyDampingFactor = 0.8

	resolveBlockAndSphere = (block, sphere, blockModel) ->
		result = hitTests.blockAndSphere blockModel, sphere
		if not result
			return
		block.events.emit 'collision', sphere, result
		sphere.events.emit 'collision', block

	resolveStructureAndShip = (structure, ship, blockModel) ->
		result = hitTests.blockAndSphere blockModel, ship
		if not result
			return
		# coord = result.coord
		# point = coordUtils.coordToPoint coord, blockModel
		# worldPoint = structure.object.localToWorld point

		# diff = new THREE.Vector3().subVectors ship.object.position, worldPoint
			
		# distance = diff.length()

		# delta = ship.radius - distance

		# if delta < 0
		# 	delta = 0

		dir = new THREE.Vector3().subVectors ship.object.position, structure.object.position

		contactForce = dir.setLength contactForceAmount
		contactForce.y = 0
		ship.applyForce contactForce
		ship.setVelocity ship.getVelocity().multiplyScalar rigidBodyDampingFactor

	onContact = (a, b) ->
		blockModela = app.getComponent a.object, 'blockModel'
		blockModelb = app.getComponent b.object, 'blockModel'

		if not blockModela? and not blockModelb?
			a.events.emit 'collision', b
			b.events.emit 'collision', a

		else if blockModela? and not blockModelb?
			resolveBlockAndSphere a, b, blockModela

		else if blockModelb? and not blockModela?
			resolveBlockAndSphere b, a, blockModelb

		else if blockModela? and blockModelb?
			groupA = a.body.collisionFilterGroup
			groupB = b.body.collisionFilterGroup

			if groupA is CollisionGroups.Structure and groupB is CollisionGroups.Ship
				resolveStructureAndShip a, b, blockModela

			if groupB is CollisionGroups.Structure and groupA is CollisionGroups.Ship
				resolveStructureAndShip b, a, blockModelb

	return onContact