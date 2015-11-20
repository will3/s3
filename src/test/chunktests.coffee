expect = require('chai').expect
Chunk = require '../voxel/chunk'
THREE = require 'three'
sinon = require 'sinon'

describe 'Chunk', () ->
	it 'can get object after set', () ->
		chunk = new Chunk(16)
		chunk.set 1, 2, 3, 'secret'
		expect(chunk.get 1, 2, 3).to.equal 'secret'

	it 'can get object at far index after set', () ->
		chunk = new Chunk(16)
		chunk.set 997, 998, 999, 'secret'
		expect(chunk.get 997, 998, 999).to.equal 'secret'

	describe 'getOrigin', () ->
		it 'rounds down coordinate', () ->
			chunk = new Chunk(16)
			origin = chunk.getOrigin 17, 33, 21
			expect(origin).to.eql [16, 32, 16]

	describe 'addChunk', () ->
		it 'adds chunk and can get after', () ->
			chunk = new Chunk(16)
			sub = chunk.addChunk(1, 2, 3)
			expect(chunk.getChunk(0, 0, 0)).to.equal sub

	describe 'hasChunk', () ->
		it 'returns true when there is chunk', () ->
			chunk = new Chunk(16)
			chunk.addChunk(1, 2, 3)
			expect(chunk.hasChunk(0, 0, 0)).to.be.true

		it 'returns false when there is no chunk', () ->
			chunk = new Chunk(16)
			expect(chunk.hasChunk(0, 0, 0)).to.be.false

	describe 'dispose', () ->
		it 'disposes all geometries and materials', () ->
			chunk = new Chunk(16)
			sub = chunk.addChunk(1, 2, 3)
			geometry = sinon.mock(new THREE.Geometry())
			material = sinon.mock(new THREE.MeshBasicMaterial())
			geometry.expects('dispose')
			material.expects('dispose')
			sub.mesh = new THREE.Mesh(geometry.object, material.object)

			chunk.dispose()

			geometry.verify();
			material.verify();