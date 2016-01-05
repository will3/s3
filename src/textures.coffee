module.exports = 
	textures: {}
	get: (type) ->
		texture = @textures[type]
		return texture if texture?

		switch type
			when 'default'
				texture = THREE.ImageUtils.loadTexture '/images/default.png'
			when 'laser'
				texture = THREE.ImageUtils.loadTexture '/images/laser_45.png'
				texture.minFilter = THREE.NearestFilter
				texture.magFilter = THREE.NearestFilter
			else
				throw new Error 'texture for ' + type + ' not found'

		@textures[type] = texture

		return texture