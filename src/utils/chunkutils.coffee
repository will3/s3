module.exports = 
	# given chunk, get center of gravity
	# returns coord of ccg in chunk
	getCcg: (chunk) ->
		chunk.visit (i, j, k, b) ->
			console.log i, j, k

		return