Events = require('../core/brock.coffee').Events

class Damagable
	constructor: () ->
		@filterGroup = null
		@ownerId = null
		@events = new Events()

	by: (damage) ->
		if damage.ownerId is @ownerId
			return false
			
		if @filterGroup is null
			return true

		if damage.excludeMask is null
			return true

		return not damage.filterGroup & damage.excludeMask

module.exports = Damagable