class Cooldown
	constructor: () ->
		@cooldowns = {}
		@counters = {}

	tick: (dt) ->
		for type, time of @counters
			@counters[type] -= dt

	add: (type, time) ->
		@cooldowns[type] = time

	ready: (type) ->
		time = @counters[type]
		if time is undefined
			return true
		return time <= 0

	refresh: (type) ->
		#set counter
		@counters[type] = @cooldowns[type]

module.exports = Cooldown