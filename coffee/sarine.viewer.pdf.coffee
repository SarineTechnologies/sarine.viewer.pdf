class PDF extends Viewer
	constructor: (options) ->
		super(options)
		{@pdfName, @limitSize, @mode,@baseUrl} = options   	
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

		@pdfUrl = stones[0].viewers.externalPdf
		if(pdfConfig &&  pdfConfig.labtype && pdfConfig.labtype.toLowerCase() == "sarine")
			@pdfUrl = stones[0].viewers.sarineCertificatePdf
		
		@previewSrc = if @pdfUrl == undefined then null else if @pdfUrl.indexOf('?') == -1 then @pdfUrl + '.png' else (@pdfUrl.split('?')[0] + '.png?' + @pdfUrl.split('?')[1])

		if(@previewSrc == null)
			@loadNoStone().then((img) ->
				_t.createTumbnail(img)
				defer.resolve(_t)
			)
		else
			@loadImage(@previewSrc).then((img)->  	
					_t.createTumbnail(img)
					canvas = $("<canvas>")
					if(!canvas.hasClass('no_stone'))
						if((pdfConfig &&  pdfConfig.mode && pdfConfig.mode == "popup" )|| _t.element.data("mode") == "popup" ) 
							canvas.on 'click', (e) => _t.initPopup(_t.fullSrc )
							resourcesPrefix = _t.baseUrl + "atomic/v1/assets/pdf/"
							resources = [{element:'link', src: resourcesPrefix + 'external-pdf-popup.css' }]
							_t.loadAssets(resources, null)
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
			pdfDiv= $('<div class="iframe-pdf-div">') 
			if Device.isMobileOrTablet() then pdfContainerInside.addClass('mobile')
			if _t.inIframe() then pdfContainer.addClass('iframe-pdf-container-hide')
			sliderHeight = sliderWrap.height()                                                
			iframeElement = $('<iframe id="iframe-pdf" frameborder=0  type="application/pdf"></iframe>')
			domain = window.stones[0].viewersBaseUrl.split('/content')[0]
			viewer = "/web-sites/pdf-viewer-js/web/viewer.html?file="
			url = [domain, viewer,src]
			pdfUrl = url.join("")	
			iframeElement.attr 'src', pdfUrl

			closeButton = $('<input type="button" value="Close" id="closePdfReport" class="close-popup-report"/>')
			openAsLink = $('<div class="open-pdf-link-container"><a href="' + src + '" target="_blank" id="open-pdf-link"  ><svg class="icon icon-external-link">
<title>external-link</title>
<path d="M14.143 9.321v3.214c0 1.597-1.296 2.893-2.893 2.893h-8.357c-1.597 0-2.893-1.296-2.893-2.893v-8.357c0-1.597 1.296-2.893 2.893-2.893h7.071c0.181 0 0.321 0.141 0.321 0.321v0.643c0 0.181-0.141 0.321-0.321 0.321h-7.071c-0.884 0-1.607 0.723-1.607 1.607v8.357c0 0.884 0.723 1.607 1.607 1.607h8.357c0.884 0 1.607-0.723 1.607-1.607v-3.214c0-0.181 0.141-0.321 0.321-0.321h0.643c0.181 0 0.321 0.141 0.321 0.321zM18 0.643v5.143c0 0.352-0.291 0.643-0.643 0.643-0.171 0-0.331-0.070-0.452-0.191l-1.768-1.768-6.549 6.549c-0.060 0.060-0.151 0.1-0.231 0.1s-0.171-0.040-0.231-0.1l-1.145-1.145c-0.060-0.060-0.1-0.151-0.1-0.231s0.040-0.171 0.1-0.231l6.549-6.549-1.768-1.768c-0.121-0.121-0.191-0.281-0.191-0.452 0-0.352 0.291-0.643 0.643-0.643h5.143c0.352 0 0.643 0.291 0.643 0.643z"></path>
</svg></a></div>')

			pdfDiv.append openAsLink
			pdfDiv.append iframeElement
			pdfDiv.append closeButton

			pdfContainerInside.append pdfDiv

			pdfContainer.append pdfContainerInside
			sliderWrap.before pdfContainer

			isSafari = /constructor/i.test(window.HTMLElement) or ((p) ->
			  p.toString() == '[object SafariRemoteNotification]'
			)(!window['safari'] or typeof safari != 'undefined' and safari.pushNotification)
			if isSafari then pdfContainer.addClass('safari')

		$(".tooltipster-base").hide()
		
		pdfContainer.css 'display', 'block'
		$(".dashboard").hide()
		if (Device.isMobileOrTablet() and isSafari)
			$(".dashboard").css("height",window.innerHeight-100+"px")
			iframeElement.css("height",window.innerHeight-300+"px")
		else	
			$(".dashboard").css("height",window.innerHeight+"px")

		closeButton.on 'click', (=>
			pdfContainer.css 'display', 'none'
			$(".dashboard").show()
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
	createTumbnail: (img) =>
		canvas = $("<canvas>")
		imgName = if (img.src == @callbackPic || img.src.indexOf('data:image') != -1) then 'PDF-thumb no_stone' else 'PDF-thumb'	
		ctx = canvas[0].getContext('2d')	
		imgDimensions = @scaleImage(img)		
		canvas.attr({width : imgDimensions.width, height : imgDimensions.height, class : imgName})		
		ctx.drawImage(img, 0, 0, imgDimensions.width, imgDimensions.height)
		@element.append(canvas) 

@PDF = PDF
 
