class PDF extends Viewer
	constructor: (options) ->
		super(options)
		{@pdfName} = options		
		
	convertElement : () ->
		@embed = $("<embed>")				
		@element.append(@embed)

	first_init : ()->
		defer = $.Deferred()
		@embed.attr({src: @src + @pdfName, type: 'application/pdf', width: '100%', height: '100%'})		
		defer.resolve(@)
		defer

	full_init : ()-> 
		defer = $.Deferred()
		defer.resolve(@)		
		defer  
	play : () -> return
	stop : () -> return

@PDF = PDF