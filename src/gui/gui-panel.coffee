$ = require 'jquery'

module.exports = (params) ->
	params = params || {}
	blocks = params.blocks
	click = params.click || () ->

	body = $ document.body

	element = $ "<div class='panel gui-unselectable'></div>"
	body.append element

	for type, block of blocks
		row = $ "
		<div class='panel-row'>
			<div class='panel-block'>
				<img src=#{block.img} block-type=#{type}></img>
			</div>
			<div class='panel-label'>#{block.qty}</div>
		</div>"

		if block.selected
			img = row.find '.panel-block > img'
			img.addClass 'panel-highlight'
		
		element.append row

	img = $ '.panel-block > img'

	self = this
	img.click () ->
		img.each () ->
			$(this).removeClass 'panel-highlight'

		type = $(this).attr('block-type')
		$(this).addClass 'panel-highlight'

		click(type)