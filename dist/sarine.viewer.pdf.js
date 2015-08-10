
/*!
sarine.viewer.pdf - v0.3.0 -  Monday, August 10th, 2015, 9:28:21 AM 
 The source code, name, and look and feel of the software are Copyright © 2015 Sarine Technologies Ltd. All Rights Reserved. You may not duplicate, copy, reuse, sell or otherwise exploit any portion of the code, content or visual design elements without express written permission from Sarine Technologies Ltd. The terms and conditions of the sarine.com website (http://sarine.com/terms-and-conditions/) apply to the access and use of this software.
 */

(function() {
  var PDF,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PDF = (function(_super) {
    __extends(PDF, _super);

    function PDF(options) {
      PDF.__super__.constructor.call(this, options);
      this.pdfName = options.pdfName;
    }

    PDF.prototype.convertElement = function() {
      return this.element;
    };

    PDF.prototype.first_init = function() {
      var defer, _t;
      defer = $.Deferred();
      this.fullSrc = this.src.indexOf('##FILE_NAME##') !== -1 ? this.src.replace('##FILE_NAME##', this.pdfName) : this.src + this.pdfName;
      _t = this;
      this.previewSrc = this.fullSrc.indexOf('?') === -1 ? this.fullSrc + '.png' : this.fullSrc.split('?')[0] + '.png';
      return this.loadImage(this.previewSrc).then(function(img) {
        var canvas, ctx, imgName;
        canvas = $("<canvas>");
        ctx = canvas[0].getContext('2d');
        imgName = 'CertPDF';
        canvas.attr({
          width: img.width,
          height: img.height,
          "class": imgName
        });
        ctx.drawImage(img, 0, 0, img.width, img.height);
        _t.element.append(canvas);
        canvas.on('click', (function(_this) {
          return function(e) {
            return window.open(_t.fullSrc, '_blank');
          };
        })(this));
        return defer.resolve(_t);
      });
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
