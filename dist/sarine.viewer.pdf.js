
/*!
sarine.viewer.pdf - v0.0.11 -  Thursday, February 19th, 2015, 11:37:59 AM 
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
      console.log('load pdf');
    }

    PDF.prototype.convertElement = function() {
      this.object = $("<object>");
      return this.element.append(this.object);
    };

    PDF.prototype.first_init = function() {
      var defer, htmlVal;
      defer = $.Deferred();
      this.object.attr({
        data: this.src + this.pdfName,
        type: 'application/pdf',
        width: '100%',
        height: '100%'
      });
      htmlVal = "<p>It appears you do not have a PDF plugin for this browser.<br />No biggie... you can <a href='" + this.src + this.pdfName + "'>click here to download the PDF file.</a></p>";
      this.object.html(htmlVal);
      defer.resolve(this);
      return defer;
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
