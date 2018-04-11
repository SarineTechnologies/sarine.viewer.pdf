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
			if _t.isMobileOrTablet() then pdfContainerInside.addClass('mobile')
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
		if (_t.isMobileOrTablet() and isSafari)
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

	isMobileOrTablet : ()->
		res = false;
		a = navigator.userAgent || navigator.vendor || window.opera
		if (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino|android|ipad|playbook|silk/i.test(a) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0, 4))) then res = true
		return res;

@PDF = PDF
 