class Damage
	constructor: () ->
		@size = 3
		@damageTable = [1, 0.75, 0.5, 0.25]

		# exclude mask
		@excludeMask = null

module.exports = Damage