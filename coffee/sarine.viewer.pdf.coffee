###!
sarine.viewer.pdf - v0.0.13 -  Sunday, March 1st, 2015, 12:02:24 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
###
class PDF extends Viewer
	constructor: (options) ->
		super(options)
		{@pdfName} = options 		
		
		console.log('load pdf')
	convertElement : () ->
		@object = $("<object>")				
		@element.append(@object)

	first_init : ()->
		defer = $.Deferred()
		@object.attr({data: @src + @pdfName, type: 'application/pdf', width: '100%', height: '100%'}) 	
		htmlVal = "<p>It appears you don't have Adobe Reader or PDF support in this web browser. <a target='_blank' href='#{@src}#{@pdfName}' target='_blank'>click here to download the PDF.</a></p>" 
		@object.html htmlVal
		defer.resolve(@)
		defer

	full_init : ()-> 
		defer = $.Deferred()
		defer.resolve(@)		
		defer  
	play : () -> return
	stop : () -> return

@PDF = PDF