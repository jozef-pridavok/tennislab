include "lib://uix/control.ms"
include "lib://uix/web/richText.ms"

/**
@class WebView
*/
class WebView : Control
{
    var paint = null;

    // @region Initialization

    function beforeInit()
    {
        super.beforeInit();

        paint = new Paint();
        paint.color = 0xff000000;
        paint.textSize = System.height / 30;
        paint.style = #stroke;
    }

    function init()
    {
        super.init(Moscrif.ScrollView);

        this._view.width = this.options.width || 100;
        this._view.height = this.options.height || 100;
        this._subclass = this._view.subclass("WebView");
        if (this._subclass) {
            // TODO: set other properties
            this._subclass.zoomable = true;
            this._subclass.backgroundColor = 0xffffffff;
        } else {
            // mimic simple control
            this._impl = new Moscrif.View();
            this._impl.onDraw = function(sender, canvas) {
                //canvas.drawRect(0, 0, this.width, this.height, this._paint);
                //canvas.drawLine(0, 0, this.width, this.height, this._paint);
                //canvas.drawLine(this.width, 0, 0, this.height, this._paint);
                if (this._rt)
                    this._rt.draw(canvas);
                if (this._text)
                    canvas.drawTextBox(this._text, 0, 0, this.width, this.height, paint);
            }
            this._impl.left = 0 this._impl.top = 0;
            this._impl.width = 10;
            this._impl.height = 10;
            this._view.dockContent = #left-top;
            this._view.scrollMode = #vert;
            this._view.add(this._impl);

            /* just text drawing
            this.onDraw = function(canvas)
            {
                canvas.drawRect(0, 0, this.width, this.height, this._paint);
                canvas.drawLine(0, 0, this.width, this.height, this._paint);
                canvas.drawLine(this.width, 0, 0, this.height, this._paint);
                //console << this.html << "\n";
                var html = this.htmlToText(this.html);
                //console << html << "\n";
                canvas.drawTextBox(html, 0, 0, this.width, this.height, this._paint);
            */
        }
    }

    function afterInit()
    {
        super.afterInit();
        //this.htmlToText(v)
    }

    // @endregion

    property html(v) {
        get return this._html;
        set {
            this._html = v;
            if (this._subclass) {
                this._subclass.loadHTML("<meta id=\"vp\" name=\"viewport\" content=\"width=" + this.width.toString() + ",initial-scale=1.0\">" + v);
            } else {
                /*
                var rt = new RichText({text:this.htmlToText(v.substr(0, 1000)), left:0, top:0, width:this._impl.width, height:this._impl.height});
                this._impl._rt = rt;
                var (w, h) = rt.textBounds();
                dlogI("bounds", w, h);
                this._impl.width = Integer.min(2000, w);
                this._impl.height = Integer.min(1000, h);
                this._impl.invalidate();
                */
                //var (w, h) = this._paint.measureTextBox(v);
                this._impl._text = this.htmlToText(v);
                this._impl.width = this._view.width;
                this._impl.height = 3 * this._view.height;// 100+paint.measureTextBox(this._impl._text, 0, 0, this._impl.width, 1); //this._view.height * 3;
            }
        }
    }

    function htmlToText(html) {
        return html
        // Remove control characters
        .replace(/\c/ig,"")
        // Turn <br>'s into single line breaks.
        .replace(/<\s*br[^>]*>/ig,"") // \n
        // Turn </li>'s into line breaks.
          .replace(/<\s*\/li[^>]*>/ig,"") // \n
        // Turn <p>'s into double line breaks.
          .replace(/<\s*p[^>]*>/ig,"") // \n\n
        // Remove content in script tags.
          .replace(/<\s*script[^>]*>[\s\S]*<\/script>/mig,"")
        // Remove content in style tags.
          .replace(/<\s*style[^>]*>[\s\S]*<\/style>/mig,"")
        // Remove content in comments.
          .replace(/<!--.*-->/mig,"")
        // Remove all remaining tags.
          .replace(/(<([^>]+)>)/ig,"")
        // Replace multiple spaces with a single space.
          .replace(/ {2,}/g," ")
        // Decode HTML entities.
          .replace(/&([^;]+);/g, decodeHtmlEntity );
    }
    
    function decodeHtmlEntity(m, n) {
        // Determine the character code of the entity. Range is 0 to 65535
        // (characters in JavaScript are Unicode, and entities can represent
        // Unicode characters).
        var code;
        
        // Try to parse as numeric entity. This is done before named entities for
        // speed because associative array lookup in many JavaScript implementations
        // is a linear search.
        if (n.substr(0, 1) == '#') {
            // Try to parse as numeric entity
            if (n.substr(1, 1) == 'x') {
                // Try to parse as hexadecimal
                code = parseInt(n.substr(2), 16);
            } else {
                // Try to parse as decimal
                code = parseInt(n.substr(1), 10);
            }
        } else {
            // Try to parse as named entity
            code = ENTITIES_MAP[n];
        }
        
        // If still nothing, pass entity through
        return (code === undefined/* || code === NaN*/)
            ? '&' + n + ';'
            : String.fromCharCode(code);
    }
    
    var ENTITIES_MAP = {
        "nbsp" : 160,
        "iexcl" : 161,
        "cent" : 162,
        "pound" : 163,
        "curren" : 164,
        "yen" : 165,
        "brvbar" : 166,
        "sect" : 167,
        "uml" : 168,
        "copy" : 169,
        "ordf" : 170,
        "laquo" : 171,
        "not" : 172,
        "shy" : 173,
        "reg" : 174,
        "macr" : 175,
        "deg" : 176,
        "plusmn" : 177,
        "sup2" : 178,
        "sup3" : 179,
        "acute" : 180,
        "micro" : 181,
        "para" : 182,
        "middot" : 183,
        "cedil" : 184,
        "sup1" : 185,
        "ordm" : 186,
        "raquo" : 187,
        "frac14" : 188,
        "frac12" : 189,
        "frac34" : 190,
        "iquest" : 191,
        "Agrave" : 192,
        "Aacute" : 193,
        "Acirc" : 194,
        "Atilde" : 195,
        "Auml" : 196,
        "Aring" : 197,
        "AElig" : 198,
        "Ccedil" : 199,
        "Egrave" : 200,
        "Eacute" : 201,
        "Ecirc" : 202,
        "Euml" : 203,
        "Igrave" : 204,
        "Iacute" : 205,
        "Icirc" : 206,
        "Iuml" : 207,
        "ETH" : 208,
        "Ntilde" : 209,
        "Ograve" : 210,
        "Oacute" : 211,
        "Ocirc" : 212,
        "Otilde" : 213,
        "Ouml" : 214,
        "times" : 215,
        "Oslash" : 216,
        "Ugrave" : 217,
        "Uacute" : 218,
        "Ucirc" : 219,
        "Uuml" : 220,
        "Yacute" : 221,
        "THORN" : 222,
        "szlig" : 223,
        "agrave" : 224,
        "aacute" : 225,
        "acirc" : 226,
        "atilde" : 227,
        "auml" : 228,
        "aring" : 229,
        "aelig" : 230,
        "ccedil" : 231,
        "egrave" : 232,
        "eacute" : 233,
        "ecirc" : 234,
        "euml" : 235,
        "igrave" : 236,
        "iacute" : 237,
        "icirc" : 238,
        "iuml" : 239,
        "eth" : 240,
        "ntilde" : 241,
        "ograve" : 242,
        "oacute" : 243,
        "ocirc" : 244,
        "otilde" : 245,
        "ouml" : 246,
        "divide" : 247,
        "oslash" : 248,
        "ugrave" : 249,
        "uacute" : 250,
        "ucirc" : 251,
        "uuml" : 252,
        "yacute" : 253,
        "thorn" : 254,
        "yuml" : 255,
        "quot" : 34,
        "amp" : 38,
        "lt" : 60,
        "gt" : 62,
        "OElig" : 338,
        "oelig" : 339,
        "Scaron" : 352,
        "scaron" : 353,
        "Yuml" : 376,
        "circ" : 710,
        "tilde" : 732,
        "ensp" : 8194,
        "emsp" : 8195,
        "thinsp" : 8201,
        "zwnj" : 8204,
        "zwj" : 8205,
        "lrm" : 8206,
        "rlm" : 8207,
        "ndash" : 8211,
        "mdash" : 8212,
        "lsquo" : 8216,
        "rsquo" : 8217,
        "sbquo" : 8218,
        "ldquo" : 8220,
        "rdquo" : 8221,
        "bdquo" : 8222,
        "dagger" : 8224,
        "Dagger" : 8225,
        "permil" : 8240,
        "lsaquo" : 8249,
        "rsaquo" : 8250,
        "euro" : 8364
    };

}