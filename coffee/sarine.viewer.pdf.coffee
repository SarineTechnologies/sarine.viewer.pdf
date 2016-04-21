###!
sarine.viewer.pdf - v0.10.0 -  Thursday, April 21st, 2016, 11:41:56 AM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
###
class PDF extends Viewer
	constructor: (options) ->
		super(options)
		{@pdfName, @limitSize} = options   	
		@limitSize = @limitSize || 250	
		
	convertElement : () -> 
		@element

	first_init : ()-> 
		defer = $.Deferred()
		@fullSrc = if @src.indexOf('##FILE_NAME##') != -1 then @src.replace '##FILE_NAME##' , @pdfName else @src + @pdfName 
		_t = @	 
		timestamp = new Date().getTime()
		@previewSrc = if @fullSrc.indexOf('?') == -1 then @fullSrc + '.png?' + timestamp else (@fullSrc.split('?')[0] + '.png?' + @fullSrc.split('?')[1] + timestamp) 
		@loadImage(@previewSrc).then((img)->  	
				image = $("<img>")
				imgName = 'PDF-thumb'	
				
				imgDimensions = _t.scaleImage(img)
				image.attr({src : img.src, alt : imgName, class : imgName, width : imgDimensions.width, height : imgDimensions.height})
				if (img.src.indexOf('data:image') != -1 || img.src == _t.callbackPic)
					image.addClass('no_stone')
					
				_t.element.append(image)
				if(!image.hasClass('no_stone'))
					image.on 'click', (e) => window.open(_t.fullSrc , '_blank') 
					image.attr {'style':'cursor:pointer;'}
				defer.resolve(_t)												
			)

	scaleImage : (img)=>
		imgDimensions = {}
		imgDimensions.width = img.width
		imgDimensions.height = img.height 
		if(img.width < @limitSize || img.height < @limitSize)
			return imgDimensions

		widthBigger = img.width > img.height 
		if(widthBigger)
			scale = img.width / @limitSize
			imgDimensions.width = @limitSize
			imgDimensions.height = img.height / scale
		else
			scale = img.height / @limitSize
			imgDimensions.height = @limitSize
			imgDimensions.width = img.width / scale

		return imgDimensions

	full_init : ()-> 
		defer = $.Deferred() 
		defer.resolve(@)		
		defer  
	play : () -> return 
	stop : () -> return

@PDF = PDF
 
