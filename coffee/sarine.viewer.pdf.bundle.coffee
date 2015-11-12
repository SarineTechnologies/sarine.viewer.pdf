###!
sarine.viewer.pdf - v0.9.0 -  Thursday, November 12th, 2015, 2:34:11 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
###

class Viewer
  rm = ResourceManager.getInstance();
  constructor: (options) ->
    console.log("")
    @first_init_defer = $.Deferred()
    @full_init_defer = $.Deferred()
    {@src, @element,@autoPlay,@callbackPic} = options
    @id = @element[0].id;
    @element = @convertElement()
    Object.getOwnPropertyNames(Viewer.prototype).forEach((k)-> 
      if @[k].name == "Error" 
          console.error @id, k, "Must be implement" , @
    ,
      @)
    @element.data "class", @
    @element.on "play", (e)-> $(e.target).data("class").play.apply($(e.target).data("class"),[true])
    @element.on "stop", (e)-> $(e.target).data("class").stop.apply($(e.target).data("class"),[true])
    @element.on "cancel", (e)-> $(e.target).data("class").cancel().apply($(e.target).data("class"),[true])
  error = () ->
    console.error(@id,"must be implement" )
  first_init: Error
  full_init: Error
  play: Error
  stop: Error
  convertElement : Error
  cancel : ()-> rm.cancel(@)
  loadImage : (src)-> rm.loadImage.apply(@,[src])
  setTimeout : (delay,callback)-> rm.setTimeout.apply(@,[@delay,callback]) 
    
@Viewer = Viewer 

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
		@previewSrc = if @fullSrc.indexOf('?') == -1 then @fullSrc + '.png' else (@fullSrc.split('?')[0] + '.png?' + @fullSrc.split('?')[1]) 
		@loadImage(@previewSrc).then((img)->  	
				image = $("<img>")
				imgName = 'PDF-thumb'	
				
				imgDimensions = _t.scaleImage(img)
				image.attr({src : img.src, alt : imgName, class : imgName, width : imgDimensions.width, height : imgDimensions.height})
				if img.src == _t.callbackPic then image.addClass 'no_stone'
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
 


