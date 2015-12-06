class ParticleGroups
	constructor: () ->
		@groups = {}

	add: (type, group) ->
		@groups[type] = group

	get: (type) -> 
		return @groups[type]

	remove: (type) ->
		delete @groups[type]

	tick: (dt) ->
		for type, group of @groups
			group.tick dt * 0.001
		return

module.exports = ParticleGroups