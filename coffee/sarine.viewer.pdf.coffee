###!
sarine.viewer.pdf - v0.3.0 -  Monday, August 10th, 2015, 9:28:21 AM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
###
class PDF extends Viewer
	constructor: (options) ->
		super(options)
		{@pdfName} = options 		
		
	convertElement : () ->
		@element

	first_init : ()-> 
		defer = $.Deferred()
		@fullSrc = if @src.indexOf('##FILE_NAME##') != -1 then @src.replace '##FILE_NAME##' , @pdfName else @src + @pdfName 
		_t = @	 
		@previewSrc = if @fullSrc.indexOf('?') == -1 then @fullSrc + '.png' else @fullSrc.split('?')[0] + '.png'
		@loadImage(@previewSrc).then((img)->  				
				canvas = $("<canvas>")
				ctx = canvas[0].getContext('2d')				
				imgName = 'CertPDF'
				canvas.attr({width : img.width, height : img.height, class : imgName})		
				ctx.drawImage(img, 0, 0, img.width, img.height) 				
				_t.element.append(canvas)
				canvas.on 'click', (e) => window.open(_t.fullSrc , '_blank') 
				defer.resolve(_t)												
			)

	full_init : ()-> 
		defer = $.Deferred()
		defer.resolve(@)		
		defer  
	play : () -> return
	stop : () -> return

@PDF = PDF
 