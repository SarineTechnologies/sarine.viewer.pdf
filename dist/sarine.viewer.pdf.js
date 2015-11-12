
/*!
sarine.viewer.pdf - v0.9.0 -  Thursday, November 12th, 2015, 2:34:11 PM 
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
      PDF.__super__.constructor.call(this, options);
      this.pdfName = options.pdfName, this.limitSize = options.limitSize;
      this.limitSize = this.limitSize || 250;
    }

    PDF.prototype.convertElement = function() {
      return this.element;
    };

    PDF.prototype.first_init = function() {
      var defer, _t;
      defer = $.Deferred();
      this.fullSrc = this.src.indexOf('##FILE_NAME##') !== -1 ? this.src.replace('##FILE_NAME##', this.pdfName) : this.src + this.pdfName;
      _t = this;
      this.previewSrc = this.fullSrc.indexOf('?') === -1 ? this.fullSrc + '.png' : this.fullSrc.split('?')[0] + '.png?' + this.fullSrc.split('?')[1];
      return this.loadImage(this.previewSrc).then(function(img) {
        var image, imgDimensions, imgName;
        image = $("<img>");
        imgName = 'PDF-thumb';
        imgDimensions = _t.scaleImage(img);
        image.attr({
          src: img.src,
          alt: imgName,
          "class": imgName,
          width: imgDimensions.width,
          height: imgDimensions.height
        });
        if (img.src === _t.callbackPic) {
          image.addClass('no_stone');
        }
        _t.element.append(image);
        if (!image.hasClass('no_stone')) {
          image.on('click', (function(_this) {
            return function(e) {
              return window.open(_t.fullSrc, '_blank');
            };
          })(this));
          image.attr({
            'style': 'cursor:pointer;'
          });
        }
        return defer.resolve(_t);
      });
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
