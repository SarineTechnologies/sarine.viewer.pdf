
/*!
sarine.viewer.pdf - v0.14.7 -  Sunday, January 14th, 2018, 2:31:09 PM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
 */

(function() {
  var PDF,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

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
      var closeButton, domain, iframeElement, openAsLink, pdfContainer, pdfContainerInside, pdfDiv, pdfUrl, sliderHeight, sliderWrap, url, viewer, _t;
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
        viewer = "/web-sites/pdf-viewer-js/web/viewer.html/?file=";
        url = [domain, viewer, src];
        pdfUrl = url.join();
        iframeElement.attr('src', pdfUrl);
        closeButton = $('<input type="button" value="Close" id="closePdfReport" class="close-popup-report"/>');
        openAsLink = $('<div class="open-pdf-link-container"><a href="' + src + '" target="_blank" id="open-pdf-link"  ><svg class="icon icon-external-link"> <title>external-link</title> <path d="M22 14.5v5c0 2.484-2.016 4.5-4.5 4.5h-13c-2.484 0-4.5-2.016-4.5-4.5v-13c0-2.484 2.016-4.5 4.5-4.5h11c0.281 0 0.5 0.219 0.5 0.5v1c0 0.281-0.219 0.5-0.5 0.5h-11c-1.375 0-2.5 1.125-2.5 2.5v13c0 1.375 1.125 2.5 2.5 2.5h13c1.375 0 2.5-1.125 2.5-2.5v-5c0-0.281 0.219-0.5 0.5-0.5h1c0.281 0 0.5 0.219 0.5 0.5zM28 1v8c0 0.547-0.453 1-1 1-0.266 0-0.516-0.109-0.703-0.297l-2.75-2.75-10.187 10.187c-0.094 0.094-0.234 0.156-0.359 0.156s-0.266-0.063-0.359-0.156l-1.781-1.781c-0.094-0.094-0.156-0.234-0.156-0.359s0.063-0.266 0.156-0.359l10.187-10.187-2.75-2.75c-0.187-0.187-0.297-0.438-0.297-0.703 0-0.547 0.453-1 1-1h8c0.547 0 1 0.453 1 1z"></path> </svg></a></div>');
        pdfDiv.append(openAsLink);
        pdfDiv.append(iframeElement);
        pdfDiv.append(closeButton);
        pdfContainerInside.append(pdfDiv);
        pdfContainer.append(pdfContainerInside);
        sliderWrap.before(pdfContainer);
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

    return PDF;

  })(Viewer);

  this.PDF = PDF;

}).call(this);
