###!
sarine.viewer.pdf - v0.3.0 -  Thursday, July 9th, 2015, 1:32:11 PM 
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
		@fullSrc = if @src.indexOf('##FILE_NAME##') != -1 then @src.replace '##FILE_NAME##' , @pdfName else @src + @pdfName   			
		@object.attr({data: @fullSrc, type: 'application/pdf', width: '100%', height: '100%'}) 	
		htmlVal = "<p>It appears you don't have Adobe Reader or PDF support in this web browser. <a target='_blank' href='#{@src}#{@pdfName}'>click here to download the PDF.</a></p>" 
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