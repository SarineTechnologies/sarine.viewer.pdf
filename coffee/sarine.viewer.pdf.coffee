class PDF extends Viewer
	constructor: (options) ->
		super(options)		

	convertElement : () ->
		@embed = $("<embed>")				
		@element.append(@embed)

	first_init : ()->
		@embed.attr({src: @src, type: 'application/pdf', width: '100%', height: '500'})		

	full_init : ()-> return
	play : () ->
	stop : () ->

@Viewer.PDF = PDF