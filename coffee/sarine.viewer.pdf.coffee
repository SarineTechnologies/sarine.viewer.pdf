###!
sarine.viewer.pdf - v0.14.7 -  Thursday, January 18th, 2018, 3:13:42 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
###
class PDF extends Viewer
	constructor: (options) ->
		super(options)
		{@pdfName, @limitSize, @mode} = options   	
		@limitSize = @limitSize || 250	
		@baseUrl = options.baseUrl + "atomic/v1/assets/"
		
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
			pdfDiv= $('<div class="iframe-pdf-div" style="display:none">') 
			if Device.isMobileOrTablet() then pdfContainerInside.addClass('mobile')
			if _t.inIframe() then pdfContainer.addClass('iframe-pdf-container-hide')  			
			prev='<svg class="icon icon-angle-left"><path d="M15.429 9v1.286c0 0.683-0.452 1.286-1.175 1.286h-7.071l2.943 2.953c0.241 0.231 0.382 0.563 0.382 0.904s-0.141 0.673-0.382 0.904l-0.753 0.763c-0.231 0.231-0.563 0.372-0.904 0.372s-0.673-0.141-0.914-0.372l-6.539-6.549c-0.231-0.231-0.372-0.563-0.372-0.904s0.141-0.673 0.372-0.914l6.539-6.529c0.241-0.241 0.573-0.382 0.914-0.382s0.663 0.141 0.904 0.382l0.753 0.743c0.241 0.241 0.382 0.573 0.382 0.914s-0.141 0.673-0.382 0.914l-2.943 2.943h7.071c0.723 0 1.175 0.603 1.175 1.286z"></path></svg>'
			next='<svg class="icon icon-angle-right"><path d="M14.786 9.643c0 0.342-0.131 0.673-0.372 0.914l-6.539 6.539c-0.241 0.231-0.573 0.372-0.914 0.372s-0.663-0.141-0.904-0.372l-0.753-0.753c-0.241-0.241-0.382-0.573-0.382-0.914s0.141-0.673 0.382-0.914l2.943-2.943h-7.071c-0.723 0-1.175-0.603-1.175-1.286v-1.286c0-0.683 0.452-1.286 1.175-1.286h7.071l-2.943-2.953c-0.241-0.231-0.382-0.563-0.382-0.904s0.141-0.673 0.382-0.904l0.753-0.753c0.241-0.241 0.563-0.382 0.904-0.382s0.673 0.141 0.914 0.382l6.539 6.539c0.241 0.231 0.372 0.563 0.372 0.904z"></path></svg>'
			pagerDiv='<div id="pdf-pager">  <button id="prev">' + prev + '</button>  <button id="next">' + next + '</button></div>'
			iframeElement = $('<div id="iframe-pdf"><canvas id="the-canvas"></canvas></div>')
			closeButton = $('<input type="button" value="Close" id="closePdfReport" class="close-popup-report"/>')
			openAsLink = $('<div class="open-pdf-link-container"><a href="' + src + '" target="_blank" id="open-pdf-link"  ><svg class="icon icon-external-link">
<title>external-link</title>
<path d="M14.143 9.321v3.214c0 1.597-1.296 2.893-2.893 2.893h-8.357c-1.597 0-2.893-1.296-2.893-2.893v-8.357c0-1.597 1.296-2.893 2.893-2.893h7.071c0.181 0 0.321 0.141 0.321 0.321v0.643c0 0.181-0.141 0.321-0.321 0.321h-7.071c-0.884 0-1.607 0.723-1.607 1.607v8.357c0 0.884 0.723 1.607 1.607 1.607h8.357c0.884 0 1.607-0.723 1.607-1.607v-3.214c0-0.181 0.141-0.321 0.321-0.321h0.643c0.181 0 0.321 0.141 0.321 0.321zM18 0.643v5.143c0 0.352-0.291 0.643-0.643 0.643-0.171 0-0.331-0.070-0.452-0.191l-1.768-1.768-6.549 6.549c-0.060 0.060-0.151 0.1-0.231 0.1s-0.171-0.040-0.231-0.1l-1.145-1.145c-0.060-0.060-0.1-0.151-0.1-0.231s0.040-0.171 0.1-0.231l6.549-6.549-1.768-1.768c-0.121-0.121-0.191-0.281-0.191-0.452 0-0.352 0.291-0.643 0.643-0.643h5.143c0.352 0 0.643 0.291 0.643 0.643z"></path>
</svg></a></div>')
			loader = '<div class="loader popup-loader"><div class="pre-load"></div></div>'

			pdfDiv.append openAsLink
			openAsLink.append pagerDiv
			pdfDiv.append iframeElement
			pdfDiv.append closeButton

			pdfContainerInside.append pdfDiv
			pdfContainerInside.append loader

			pdfContainer.append pdfContainerInside
			sliderWrap.before pdfContainer
			_t.render_pdf(src)



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

	onPrevPage : () ->
		_this=@
		if(_this.pageNum <= 1) 
			return

		_this.pageNum-- 	

		if(_this.pageNum <= 1) 
			$("#prev").addClass	"icon-disable"
			$("#next").removeClass	"icon-disable"
		else
			$("#prev").removeClass	"icon-disable"
		_this.queueRenderPage(_this.pageNum)


	onNextPage :() ->		
		_this=@
		if(_this.pageNum >= _this.pdfDoc.numPages)  
			return

		_this.pageNum++  

		if(_this.pageNum >= _this.pdfDoc.numPages) 
			$("#next").addClass	"icon-disable"
			$("#prev").removeClass	"icon-disable"	
		else
			$("#next").removeClass	"icon-disable"

		_this.queueRenderPage(_this.pageNum)

# If absolute URL from the remote server is provided, configure the CORS
# header on that server.
	render_pdf : (url)-> 
		_t = @   		
	# The workerSrc property shall be specified.
		
		_t.pdfDoc = null   		
		_t.pageNum = 1    	
		_t.pageRendering = false    	
		_t.pageNumPending = null    	
		_t.scale = 0.8    	
		_t.canvas = document.getElementById('the-canvas')    	
		_t.ctx = _t.canvas.getContext('2d')		
		assets = [{element:'script',src: '//mozilla.github.io/pdf.js/build/pdf.js' }]		#@baseUrl + 'pdf.js'
		_t.loadAssets(assets,()->		  
			PDFJS.workerSrc =  '//mozilla.github.io/pdf.js/build/pdf.worker.js'  #@baseUrl + 'pdf.worker.js'
			PDFJS.getDocument(url).then (pdfDoc_) ->
				_t.pdfDoc = pdfDoc_
				if(_t.pdfDoc.numPages > 1)
					document.getElementById('prev').addEventListener('click', _t.onPrevPage.bind(_t))
					document.getElementById('next').addEventListener('click', _t.onNextPage.bind(_t))
				else
					$("#pdf-pager").css 'display', 'none' 
				$("#prev").addClass	"icon-disable"
				_t.renderPage(_t.pageNum))

	renderPage : (num) ->
		_t = @  		
		_t.pageRendering = true		
		_t.pdfDoc.getPage(num).then (page) ->    
			#calculate canvas weight	 	
			viewport = page.getViewport(1)
			desiredWidth = document.getElementsByClassName("iframe-pdf-inside-container")[0].offsetWidth
			scale =  desiredWidth / viewport.width

			scaledViewport = page.getViewport(scale)

			_t.canvas.height = scaledViewport.height
			_t.canvas.width	= scaledViewport.width

			renderContext = 	      		
				canvasContext: _t.ctx,	      		
				viewport: scaledViewport	  
			$(".popup-loader").css "display","block"	  	
			renderTask = page.render(renderContext)	    	
			renderTask.promise.then () ->
				_t.pageRendering = false	
				$(".iframe-pdf-div").css "display","block"
				$(".popup-loader").css "display","none"				
				if(_t.pageNumPending != null) 
					_t.renderPage(_t.pageNumPending)
					_t.pageNumPending = null

	


#If another page rendering in progress, waits until the rendering is
 # finised. Otherwise, executes rendering immediately.
	queueRenderPage : (num) ->
		_t = @  		
		if(_t.pageRendering) 
  			_t.pageNumPending = num
  		else  _t.renderPage(num)
 

@PDF = PDF
 
