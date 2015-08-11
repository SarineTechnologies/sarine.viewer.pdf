###!
sarine.viewer.pdf - v0.6.0 -  Tuesday, August 11th, 2015, 11:48:37 AM 
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
		@previewSrc = if @fullSrc.indexOf('?') == -1 then @fullSrc + '.png' else (@fullSrc.split('?')[0] + '.png?' + @fullSrc.split('?')[1]) 
		@loadImage(@previewSrc).then((img)->  	
				image = $("<img>")
				imgName = 'PDF-thumb'
				image.attr({src : img.src, alt : imgName, class : imgName, style : 'max-width:250px;max-height:250px;cursor:pointer;'})
				_t.element.append(image)
				image.on 'click', (e) => window.open(_t.fullSrc , '_blank') 
				defer.resolve(_t)												
			)

	full_init : ()-> 
		defer = $.Deferred() 
		defer.resolve(@)		
		defer  
	play : () -> return 
	stop : () -> return

@PDF = PDF
 
 