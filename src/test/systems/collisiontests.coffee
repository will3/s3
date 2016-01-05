Collision = require '../../systems/collision.coffee'
sinon = require 'sinon'
expect = require('chai').expect

describe 'Collision', () ->
	collision = null
	mock = null

	beforeEach () ->
		collision = new Collision()
		mock = sinon.mock collision

	it 'should resolve once for two bodies', () ->
		collision.bodies = 
			'a': {}
			'b': {}

		mock.expects('resolveCollision').once()

		collision.tick()

		mock.verify()

	it 'should not resolve if mask does not match group', () ->
		collision.bodies = 
			'a': group: 'a', mask: ['a']
			'b': group: 'b', mask: ['b']

		mock.expects('resolveCollision').never()

		collision.tick()

		mock.verify()