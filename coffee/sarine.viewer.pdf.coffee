class PDF extends Viewer
	constructor: (options) ->
		super(options)
		{@pdfName} = options		
		console.log('load pdf')
	convertElement : () ->
		@embed = $("<embed>")				
		@element.append(@embed)

	first_init : ()->
		@embed.attr({src: @src + @pdfName, type: 'application/pdf', width: '100%', height: '100%'})		

	full_init : ()-> return
	play : () -> return
	stop : () -> return

@PDF = PDF