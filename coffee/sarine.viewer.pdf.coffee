###!
sarine.viewer.pdf - v0.14.7 -  Sunday, January 7th, 2018, 1:33:39 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
###
class PDF extends Viewer
	constructor: (options) ->
		super(options)
		{@pdfName, @limitSize, @mode} = options   	
		@limitSize = @limitSize || 250	
		
	convertElement : () -> 
		@element

	first_init : ()-> 
		defer = $.Deferred()
		#@fullSrc = if @src.indexOf('##FILE_NAME##') != -1 then @src.replace '##FILE_NAME##' , @pdfName else @src + @pdfName 
		@fullSrc = @src

		_t = @	
		configArray = window.configuration.experiences.filter((i)-> return i.atom == 'externalPdf')
		pdfConfig = null
		if (configArray.length != 0)
			pdfConfig = configArray[0]

		@previewSrc = if @fullSrc.indexOf('?') == -1 then @fullSrc + '.png' else (@fullSrc.split('?')[0] + '.png?' + @fullSrc.split('?')[1])		
		@loadImage(@previewSrc).then((img)->  	
				canvas = $("<canvas>") 
				imgName = if (img.src == _t.callbackPic || img.src.indexOf('data:image') != -1) then 'PDF-thumb no_stone' else 'PDF-thumb'	
				ctx = canvas[0].getContext('2d')	
				imgDimensions = _t.scaleImage(img)				

				canvas.attr({width : imgDimensions.width, height : imgDimensions.height, class : imgName})		
				ctx.drawImage(img, 0, 0, imgDimensions.width, imgDimensions.height)
				_t.element.append(canvas) 

				if(!canvas.hasClass('no_stone'))
					if((pdfConfig &&  pdfConfig.mode && pdfConfig.mode == "popup" )|| _t.element.data("mode") == "popup" ) then canvas.on 'click', (e) => _t.initPopup(_t.fullSrc )
					else canvas.on 'click', (e) => window.open(_t.fullSrc , '_blank') 
					canvas.attr {'style':'cursor:pointer;'}
				defer.resolve(_t)											
			)

	initPopup : (src)=>
	 _t = @
		sliderWrap = $("body").children().first()
		pdfContainer = $('#iframe-pdf-container')
		iframeElement = $('#iframe-pdf')
		closeButton = $('#closePdfIframe')
		if (pdfContainer.length == 0)
			pdfContainer = $('<div id="iframe-pdf-container" class="pdf-popup-container">')
			pdfContainerInside =$('<div class="iframe-pdf-inside-container ">') 
			if Device.isMobileOrTablet() then pdfContainerInside.addClass('mobile')
			if _t.inIframe() then pdfContainer.addClass('iframe-pdf-container-hide')
			sliderHeight = sliderWrap.height()                                                
			iframeElement = $('<iframe id="iframe-pdf" frameborder=0></iframe>')
			closeButton = $('<input type="button" value="Close" id="closePdfReport" class="close-popup-report"/>')
			openAsLink = $('<div class="open-pdf-link-container"><a href="' + src + '" target="_blank" id="open-pdf-link"  ><svg class="icon icon-external-link">
<title>external-link</title>
<path d="M22 14.5v5c0 2.484-2.016 4.5-4.5 4.5h-13c-2.484 0-4.5-2.016-4.5-4.5v-13c0-2.484 2.016-4.5 4.5-4.5h11c0.281 0 0.5 0.219 0.5 0.5v1c0 0.281-0.219 0.5-0.5 0.5h-11c-1.375 0-2.5 1.125-2.5 2.5v13c0 1.375 1.125 2.5 2.5 2.5h13c1.375 0 2.5-1.125 2.5-2.5v-5c0-0.281 0.219-0.5 0.5-0.5h1c0.281 0 0.5 0.219 0.5 0.5zM28 1v8c0 0.547-0.453 1-1 1-0.266 0-0.516-0.109-0.703-0.297l-2.75-2.75-10.187 10.187c-0.094 0.094-0.234 0.156-0.359 0.156s-0.266-0.063-0.359-0.156l-1.781-1.781c-0.094-0.094-0.156-0.234-0.156-0.359s0.063-0.266 0.156-0.359l10.187-10.187-2.75-2.75c-0.187-0.187-0.297-0.438-0.297-0.703 0-0.547 0.453-1 1-1h8c0.547 0 1 0.453 1 1z"></path>
</svg></a></div>')

			pdfContainerInside.append openAsLink
			pdfContainerInside.append iframeElement
			pdfContainerInside.append closeButton

			pdfContainer.append pdfContainerInside
			sliderWrap.before pdfContainer

		iframeElement.attr 'src', src

		pdfContainer.css 'display', 'block'
		closeButton.on 'click', (=>
				pdfContainer.css 'display', 'none'
				return
			)	

	inIframe :()->
		try
			return window.self != window.top
		catch e
			return true
		return				

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
 
