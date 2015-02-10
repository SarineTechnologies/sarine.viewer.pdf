class PDF extends Viewer
	constructor: (options) ->
		super(options)		

	convertElement : () ->
		@embed = $("<embed>")				
		@element.append(@embed)

	first_init : ()->
		@embed.attr({src: @src, type: 'application/pdf'})		

	full_init : ()-> return
	play : () -> return
	stop : () -> return

@PDF = PDF