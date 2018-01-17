
/*!
sarine.viewer.pdf - v0.14.7 -  Wednesday, January 17th, 2018, 2:45:34 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
 */

(function() {
  var PDF, Viewer,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Viewer = (function() {
    var error, rm;

    rm = ResourceManager.getInstance();

    function Viewer(options) {
      console.log("");
      this.first_init_defer = $.Deferred();
      this.full_init_defer = $.Deferred();
      this.src = options.src, this.element = options.element, this.autoPlay = options.autoPlay, this.callbackPic = options.callbackPic;
      this.id = this.element[0].id;
      this.element = this.convertElement();
      Object.getOwnPropertyNames(Viewer.prototype).forEach(function(k) {
        if (this[k].name === "Error") {
          return console.error(this.id, k, "Must be implement", this);
        }
      }, this);
      this.element.data("class", this);
      this.element.on("play", function(e) {
        return $(e.target).data("class").play.apply($(e.target).data("class"), [true]);
      });
      this.element.on("stop", function(e) {
        return $(e.target).data("class").stop.apply($(e.target).data("class"), [true]);
      });
      this.element.on("cancel", function(e) {
        return $(e.target).data("class").cancel().apply($(e.target).data("class"), [true]);
      });
    }

    error = function() {
      return console.error(this.id, "must be implement");
    };

    Viewer.prototype.first_init = Error;

    Viewer.prototype.full_init = Error;

    Viewer.prototype.play = Error;

    Viewer.prototype.stop = Error;

    Viewer.prototype.convertElement = Error;

    Viewer.prototype.cancel = function() {
      return rm.cancel(this);
    };

    Viewer.prototype.loadImage = function(src) {
      return rm.loadImage.apply(this, [src]);
    };

    Viewer.prototype.loadAssets = function(resources, onScriptLoadEnd) {
      var element, resource, scripts, scriptsLoaded, _i, _len;
      if (resources !== null && resources.length > 0) {
        scripts = [];
        for (_i = 0, _len = resources.length; _i < _len; _i++) {
          resource = resources[_i];
          if (resource.element === 'script') {
            scripts.push(resource.src + cacheVersion);
          } else {
            element = document.createElement(resource.element);
            element.href = resource.src + cacheVersion;
            element.rel = "stylesheet";
            element.type = "text/css";
            $(document.head).prepend(element);
          }
        }
        scriptsLoaded = 0;
        scripts.forEach(function(script) {
          return $.getScript(script, function() {
            if (++scriptsLoaded === scripts.length) {
              return onScriptLoadEnd();
            }
          });
        });
      }
    };

    Viewer.prototype.setTimeout = function(delay, callback) {
      return rm.setTimeout.apply(this, [this.delay, callback]);
    };

    return Viewer;

  })();

  this.Viewer = Viewer;

  PDF = (function(_super) {
    __extends(PDF, _super);

    function PDF(options) {
      this.scaleImage = __bind(this.scaleImage, this);
      this.initPopup = __bind(this.initPopup, this);
      PDF.__super__.constructor.call(this, options);
      this.pdfName = options.pdfName, this.limitSize = options.limitSize, this.mode = options.mode;
      this.limitSize = this.limitSize || 250;
      this.baseUrl = options.baseUrl + "atomic/v1/assets/";
    }

    PDF.prototype.convertElement = function() {
      return this.element;
    };

    PDF.prototype.first_init = function() {
      var configArray, defer, pdfConfig, _t;
      defer = $.Deferred();
      this.fullSrc = this.src;
      _t = this;
      configArray = window.configuration.experiences.filter(function(i) {
        return i.atom === 'externalPdf';
      });
      pdfConfig = null;
      if (configArray.length !== 0) {
        pdfConfig = configArray[0];
      }
      this.previewSrc = this.fullSrc.indexOf('?') === -1 ? this.fullSrc + '.png' : this.fullSrc.split('?')[0] + '.png?' + this.fullSrc.split('?')[1];
      return this.loadImage(this.previewSrc).then(function(img) {
        var canvas, ctx, imgDimensions, imgName;
        canvas = $("<canvas>");
        imgName = img.src === _t.callbackPic || img.src.indexOf('data:image') !== -1 ? 'PDF-thumb no_stone' : 'PDF-thumb';
        ctx = canvas[0].getContext('2d');
        imgDimensions = _t.scaleImage(img);
        canvas.attr({
          width: imgDimensions.width,
          height: imgDimensions.height,
          "class": imgName
        });
        ctx.drawImage(img, 0, 0, imgDimensions.width, imgDimensions.height);
        _t.element.append(canvas);
        if (!canvas.hasClass('no_stone')) {
          if ((pdfConfig && pdfConfig.mode && pdfConfig.mode === "popup") || _t.element.data("mode") === "popup") {
            canvas.on('click', (function(_this) {
              return function(e) {
                return _t.initPopup(_t.fullSrc);
              };
            })(this));
          } else {
            canvas.on('click', (function(_this) {
              return function(e) {
                return window.open(_t.fullSrc, '_blank');
              };
            })(this));
          }
          canvas.attr({
            'style': 'cursor:pointer;'
          });
        }
        return defer.resolve(_t);
      });
    };

    PDF.prototype.initPopup = function(src) {
      var closeButton, iframeElement, next, openAsLink, pagerDiv, pdfContainer, pdfContainerInside, pdfDiv, prev, sliderWrap, _t;
      _t = this;
      sliderWrap = $("body").children().first();
      pdfContainer = $('#iframe-pdf-container');
      iframeElement = $('#iframe-pdf');
      closeButton = $('#closePdfIframe');
      if (pdfContainer.length === 0) {
        pdfContainer = $('<div id="iframe-pdf-container" class="pdf-popup-container">');
        pdfContainerInside = $('<div class="iframe-pdf-inside-container ">');
        pdfDiv = $('<div class="iframe-pdf-div" style="display:none">');
        if (Device.isMobileOrTablet()) {
          pdfContainerInside.addClass('mobile');
        }
        if (_t.inIframe()) {
          pdfContainer.addClass('iframe-pdf-container-hide');
        }
        prev = '<svg class="icon icon-angle-left"><path d="M15.429 9v1.286c0 0.683-0.452 1.286-1.175 1.286h-7.071l2.943 2.953c0.241 0.231 0.382 0.563 0.382 0.904s-0.141 0.673-0.382 0.904l-0.753 0.763c-0.231 0.231-0.563 0.372-0.904 0.372s-0.673-0.141-0.914-0.372l-6.539-6.549c-0.231-0.231-0.372-0.563-0.372-0.904s0.141-0.673 0.372-0.914l6.539-6.529c0.241-0.241 0.573-0.382 0.914-0.382s0.663 0.141 0.904 0.382l0.753 0.743c0.241 0.241 0.382 0.573 0.382 0.914s-0.141 0.673-0.382 0.914l-2.943 2.943h7.071c0.723 0 1.175 0.603 1.175 1.286z"></path></svg>';
        next = '<svg class="icon icon-angle-right"><path d="M14.786 9.643c0 0.342-0.131 0.673-0.372 0.914l-6.539 6.539c-0.241 0.231-0.573 0.372-0.914 0.372s-0.663-0.141-0.904-0.372l-0.753-0.753c-0.241-0.241-0.382-0.573-0.382-0.914s0.141-0.673 0.382-0.914l2.943-2.943h-7.071c-0.723 0-1.175-0.603-1.175-1.286v-1.286c0-0.683 0.452-1.286 1.175-1.286h7.071l-2.943-2.953c-0.241-0.231-0.382-0.563-0.382-0.904s0.141-0.673 0.382-0.904l0.753-0.753c0.241-0.241 0.563-0.382 0.904-0.382s0.673 0.141 0.914 0.382l6.539 6.539c0.241 0.231 0.372 0.563 0.372 0.904z"></path></svg>';
        pagerDiv = '<div id="pdf-pager">  <button id="prev">' + prev + '</button>  <button id="next">' + next + '</button></div>';
        iframeElement = $('<div id="iframe-pdf"><canvas id="the-canvas" style="width:100%;"></canvas></div>');
        closeButton = $('<input type="button" value="Close" id="closePdfReport" class="close-popup-report"/>');
        openAsLink = $('<div class="open-pdf-link-container"><a href="' + src + '" target="_blank" id="open-pdf-link"  ><svg class="icon icon-external-link"> <title>external-link</title> <path d="M14.143 9.321v3.214c0 1.597-1.296 2.893-2.893 2.893h-8.357c-1.597 0-2.893-1.296-2.893-2.893v-8.357c0-1.597 1.296-2.893 2.893-2.893h7.071c0.181 0 0.321 0.141 0.321 0.321v0.643c0 0.181-0.141 0.321-0.321 0.321h-7.071c-0.884 0-1.607 0.723-1.607 1.607v8.357c0 0.884 0.723 1.607 1.607 1.607h8.357c0.884 0 1.607-0.723 1.607-1.607v-3.214c0-0.181 0.141-0.321 0.321-0.321h0.643c0.181 0 0.321 0.141 0.321 0.321zM18 0.643v5.143c0 0.352-0.291 0.643-0.643 0.643-0.171 0-0.331-0.070-0.452-0.191l-1.768-1.768-6.549 6.549c-0.060 0.060-0.151 0.1-0.231 0.1s-0.171-0.040-0.231-0.1l-1.145-1.145c-0.060-0.060-0.1-0.151-0.1-0.231s0.040-0.171 0.1-0.231l6.549-6.549-1.768-1.768c-0.121-0.121-0.191-0.281-0.191-0.452 0-0.352 0.291-0.643 0.643-0.643h5.143c0.352 0 0.643 0.291 0.643 0.643z"></path> </svg></a></div>');
        pdfDiv.append(openAsLink);
        openAsLink.append(pagerDiv);
        pdfDiv.append(iframeElement);
        pdfDiv.append(closeButton);
        pdfContainerInside.append(pdfDiv);
        pdfContainer.append(pdfContainerInside);
        sliderWrap.before(pdfContainer);
        _t.render_pdf(src);
      }
      pdfContainer.css('display', 'block');
      return closeButton.on('click', ((function(_this) {
        return function() {
          pdfContainer.css('display', 'none');
        };
      })(this)));
    };

    PDF.prototype.inIframe = function() {
      var e;
      try {
        return window.self !== window.top;
      } catch (_error) {
        e = _error;
        return true;
      }
    };

    PDF.prototype.scaleImage = function(img) {
      var imgDimensions, scale, widthBigger;
      imgDimensions = {};
      imgDimensions.width = img.width;
      imgDimensions.height = img.height;
      if (img.width < this.limitSize || img.height < this.limitSize) {
        return imgDimensions;
      }
      widthBigger = img.width > img.height;
      if (widthBigger) {
        scale = img.width / this.limitSize;
        imgDimensions.width = this.limitSize;
        imgDimensions.height = img.height / scale;
      } else {
        scale = img.height / this.limitSize;
        imgDimensions.height = this.limitSize;
        imgDimensions.width = img.width / scale;
      }
      return imgDimensions;
    };

    PDF.prototype.full_init = function() {
      var defer;
      defer = $.Deferred();
      defer.resolve(this);
      return defer;
    };

    PDF.prototype.play = function() {};

    PDF.prototype.stop = function() {};

    PDF.prototype.onPrevPage = function() {
      var _this;
      _this = this;
      if (_this.pageNum <= 1) {
        return;
      }
      _this.pageNum--;
      return _this.queueRenderPage(_this.pageNum);
    };

    PDF.prototype.onNextPage = function() {
      var _this;
      _this = this;
      if (_this.pageNum >= _this.pdfDoc.numPages) {
        return;
      }
      _this.pageNum++;
      return _this.queueRenderPage(_this.pageNum);
    };

    PDF.prototype.render_pdf = function(url) {
      var assets, _t;
      _t = this;
      _t.pdfDoc = null;
      _t.pageNum = 1;
      _t.pageRendering = false;
      _t.pageNumPending = null;
      _t.scale = 0.8;
      _t.canvas = document.getElementById('the-canvas');
      _t.ctx = _t.canvas.getContext('2d');
      assets = [
        {
          element: 'script',
          src: '//mozilla.github.io/pdf.js/build/pdf.js'
        }
      ];
      return _t.loadAssets(assets, function() {
        PDFJS.workerSrc = '//mozilla.github.io/pdf.js/build/pdf.worker.js';
        return PDFJS.getDocument(url).then(function(pdfDoc_) {
          _t.pdfDoc = pdfDoc_;
          if (_t.pdfDoc.numPages > 1) {
            document.getElementById('prev').addEventListener('click', _t.onPrevPage.bind(_t));
            document.getElementById('next').addEventListener('click', _t.onNextPage.bind(_t));
          } else {
            $("#pdf-pager").css('display', 'none');
          }
          return _t.renderPage(_t.pageNum);
        });
      });
    };

    PDF.prototype.renderPage = function(num) {
      var _t;
      _t = this;
      _t.pageRendering = true;
      return _t.pdfDoc.getPage(num).then(function(page) {
        var desiredWidth, renderContext, renderTask, scale, scaledViewport, viewport;
        viewport = page.getViewport(1);
        desiredWidth = _t.canvas.width;
        scale = desiredWidth / viewport.width;
        scaledViewport = page.getViewport(scale);
        _t.canvas.height = scaledViewport.height;
        renderContext = {
          canvasContext: _t.ctx,
          viewport: scaledViewport
        };
        renderTask = page.render(renderContext);
        return renderTask.promise.then(function() {
          _t.pageRendering = false;
          $(".iframe-pdf-div").css("display", "block");
          if (_t.pageNumPending !== null) {
            _t.renderPage(_t.pageNumPending);
            return _t.pageNumPending = null;
          }
        });
      });
    };

    PDF.prototype.queueRenderPage = function(num) {
      var _t;
      _t = this;
      if (_t.pageRendering) {
        return _t.pageNumPending = num;
      } else {
        return _t.renderPage(num);
      }
    };

    return PDF;

  })(Viewer);

  this.PDF = PDF;

}).call(this);
