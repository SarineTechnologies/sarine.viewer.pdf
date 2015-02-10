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
      this.embed = $("<embed>");
      return this.element.append(this.embed);
    };

    PDF.prototype.first_init = function() {
      return this.embed.attr({
        src: this.src + this.pdfName,
        type: 'application/pdf',
        width: '100%',
        height: '100%'
      });
    };

    PDF.prototype.full_init = function() {};

    PDF.prototype.play = function() {};

    PDF.prototype.stop = function() {};

    return PDF;

  })(Viewer);

  this.PDF = PDF;

}).call(this);
