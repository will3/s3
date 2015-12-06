class ParticleManager
	constructor: () ->
		@groups = {}

	tick: (dt) ->
		for id, group of @groups
			group.tick dt

	
module.exports = ParticleManager