###!
sarine.viewer.pdf - v0.0.9 -  Tuesday, February 17th, 2015, 5:46:48 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
###

class Viewer
  rm = ResourceManager.getInstance();
  constructor: (options) ->
    @first_init_defer = $.Deferred()
    @full_init_defer = $.Deferred()
    {@src, @element,@autoPlay} = options
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
  setTimeout : (fun,delay)-> rm.setTimeout.apply(@,[@delay])
    
@Viewer = Viewer

class PDF extends Viewer
	constructor: (options) ->
		super(options)
		{@pdfName} = options		
		
		console.log('load pdf')
	convertElement : () ->
		@embed = $("<embed>")				
		@element.append(@embed)

	first_init : ()->
		defer = $.Deferred()
		@embed.attr({src: @src + @pdfName, type: 'application/pdf', width: '100%', height: '100%'})	
		htmlVal = "<p>It appears you do not have a PDF plugin for this browser.<br />No biggie... you can <a href='#{@src}#{@pdfName}'>click here to download the PDF file.</a></p>" 
		@embed.html htmlVal
		defer.resolve(@)
		defer

	full_init : ()-> 
		defer = $.Deferred()
		defer.resolve(@)		
		defer  
	play : () -> return
	stop : () -> return

@PDF = PDF

