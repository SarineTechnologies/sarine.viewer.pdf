###!
sarine.viewer.pdf - v0.0.3 -  Thursday, February 12th, 2015, 4:36:24 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
###
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