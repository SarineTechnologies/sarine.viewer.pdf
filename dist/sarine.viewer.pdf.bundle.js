
/*!
sarine.viewer.pdf - v0.14.9 -  Sunday, January 28th, 2018, 12:45:35 PM 
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
      var closeButton, domain, iframeElement, isSafari, openAsLink, pdfContainer, pdfContainerInside, pdfDiv, pdfUrl, sliderHeight, sliderWrap, url, viewer, _t;
      _t = this;
      sliderWrap = $("body").children().first();
      pdfContainer = $('#iframe-pdf-container');
      iframeElement = $('#iframe-pdf');
      closeButton = $('#closePdfIframe');
      if (pdfContainer.length === 0) {
        pdfContainer = $('<div id="iframe-pdf-container" class="pdf-popup-container">');
        pdfContainerInside = $('<div class="iframe-pdf-inside-container ">');
        pdfDiv = $('<div class="iframe-pdf-div">');
        if (Device.isMobileOrTablet()) {
          pdfContainerInside.addClass('mobile');
        }
        if (_t.inIframe()) {
          pdfContainer.addClass('iframe-pdf-container-hide');
        }
        sliderHeight = sliderWrap.height();
        iframeElement = $('<iframe id="iframe-pdf" frameborder=0  type="application/pdf"></iframe>');
        domain = window.stones[0].viewersBaseUrl.split('/content')[0];
        viewer = "/web-sites/pdf-viewer-js/web/viewer.html?file=";
        url = [domain, viewer, src];
        pdfUrl = url.join("");
        iframeElement.attr('src', pdfUrl);
        closeButton = $('<input type="button" value="Close" id="closePdfReport" class="close-popup-report"/>');
        openAsLink = $('<div class="open-pdf-link-container"><a href="' + src + '" target="_blank" id="open-pdf-link"  ><svg class="icon icon-external-link"> <title>external-link</title> <path d="M14.143 9.321v3.214c0 1.597-1.296 2.893-2.893 2.893h-8.357c-1.597 0-2.893-1.296-2.893-2.893v-8.357c0-1.597 1.296-2.893 2.893-2.893h7.071c0.181 0 0.321 0.141 0.321 0.321v0.643c0 0.181-0.141 0.321-0.321 0.321h-7.071c-0.884 0-1.607 0.723-1.607 1.607v8.357c0 0.884 0.723 1.607 1.607 1.607h8.357c0.884 0 1.607-0.723 1.607-1.607v-3.214c0-0.181 0.141-0.321 0.321-0.321h0.643c0.181 0 0.321 0.141 0.321 0.321zM18 0.643v5.143c0 0.352-0.291 0.643-0.643 0.643-0.171 0-0.331-0.070-0.452-0.191l-1.768-1.768-6.549 6.549c-0.060 0.060-0.151 0.1-0.231 0.1s-0.171-0.040-0.231-0.1l-1.145-1.145c-0.060-0.060-0.1-0.151-0.1-0.231s0.040-0.171 0.1-0.231l6.549-6.549-1.768-1.768c-0.121-0.121-0.191-0.281-0.191-0.452 0-0.352 0.291-0.643 0.643-0.643h5.143c0.352 0 0.643 0.291 0.643 0.643z"></path> </svg></a></div>');
        pdfDiv.append(openAsLink);
        pdfDiv.append(iframeElement);
        pdfDiv.append(closeButton);
        pdfContainerInside.append(pdfDiv);
        pdfContainer.append(pdfContainerInside);
        sliderWrap.before(pdfContainer);
        isSafari = /constructor/i.test(window.HTMLElement) || (function(p) {
          return p.toString() === '[object SafariRemoteNotification]';
        })(!window['safari'] || typeof safari !== 'undefined' && safari.pushNotification);
        if (isSafari) {
          pdfContainer.addClass('safari');
        }
      }
      pdfContainer.css('display', 'block');
      $(".slider-wrap,.dashboard").addClass('prevent_scroll');
      $(".dashboard").css("height", screen.height + "px");
      return closeButton.on('click', ((function(_this) {
        return function() {
          pdfContainer.css('display', 'none');
          $(".slider-wrap,.dashboard").removeClass('prevent_scroll').css("height", "auto");
          $(".dashboard").css("height", "auto");
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

    return PDF;

  })(Viewer);

  this.PDF = PDF;

}).call(this);
