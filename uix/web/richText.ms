include "lib://core/baseClass.ms"

/*

** new line

\n - new line

** font face

\b - bold
\i - italic
\u - underline
\s - strikeout

** alignment

\l - left align
\c - center align
\r - right align

** font size

\1 - size
\2 - size

** color

\A
\B
\C
\D

*/

class RichText : BaseClass
{
    function init()
    {
        super.init();
        this._defaultPaint = new Paint();
        this._defaultPaint.textSize = 30;
        this._defaultPaint.style = #stroke;
    }

    function afterInit()
    {
        super.afterInit();
        this._update();
    }

    property text(v)
    {
        get return this._text;
        set {
            if (this._text === v)
                return;
            this._text = v;
            if (!this.initialized)
                return;
            this._update();
        }
    }

    property left(v)
    {
        get return this._left;
        set {
            if (this._left === v)
                return;
            this._left = v;
            if (!this.initialized)
                return;
            this._update();
        }
    }

    property top(v)
    {
        get return this._top;
        set {
            if (this._top === v)
                return;
            this._top = v;
            if (!this.initialized)
                return;
            this._update();
        }
    }

    property width(v)
    {
        get return this._width;
        set {
            if (this._width === v)
                return;
            this._width = v;
            if (!this.initialized)
                return;
            this._update();
        }
    }

    property height(v)
    {
        get return this._height;
        set {
            if (this._height === v)
                return;
            this._height = v;
            if (!this.initialized)
                return;
            this._update();
        }
    }

    function textBounds()
    {
        var height = 0;
        var width = 0;
        for (var line in this._lines) {
            height += line.maxHeight;
            width += line.maxWidth;
        }
        return (width, height);
    }

    function draw(canvas)
    {
        canvas.drawRect(this._left, this._top, this._left + this._width, this._top + this._height, this._defaultPaint);
        for (var line in this._lines)
            this._draw(canvas, line);
    }

    function _draw(canvas, line)
    {
        var left = this._left;
        var top = this._top;
        //var right = left + this._width;
        //var bottom = top + this._height;
        if (line.paint.textAlign == #center)
            left += this.width / 2;
        if (line.paint.textAlign == #right)
            left += this.width;
        canvas.drawText(line.text, left, line.y + line.paint.fontSpacing, line.paint);
    }

    function _clonePaint()
    {
        var paint = new Paint();
        paint.color = this._defaultPaint.color;
        paint.textAlign = this._defaultPaint.textAlign;
        paint.textSize = this._defaultPaint.textSize;
        paint.typeface = this._defaultPaint.typeface;
        return paint;
    }

    function _updatePaint(paint, prop, val)
    {
        if (paint === this._defaultPaint)
            paint = this._clonePaint();
        switch(prop) {
            case #color:
                paint.color = val;
                break;
            case #alignment:
                paint.textAlign = val;
                break;
        }
        return paint;
    }

    function _makeLine(str)
    {
        var line = {
            text: "",
            y: -1,
            maxHeight: -1,
            maxWidth: -1,
            alignment: #left,
            paint: this._defaultPaint
        }
        var command = false;
        for (var i = 0; i < str.length; i++) {
            var ch = str.charAt(i);
            if (command) {
                switch(ch) {
                    case "l":
                        line.paint = this._updatePaint(line.paint, #alignment, #left);
                        break;
                    case "c":
                        line.paint = this._updatePaint(line.paint, #alignment, #center);
                        break;
                    case "r":
                        line.paint = this._updatePaint(line.paint, #alignment, #right);
                        break;
                    default:
                        throw String.printf("Unknown format %s", ch);
                }
                command = false;
                continue;
            }
            if (ch == "\\") {
                command = true;
                continue;
            }
            else
                line.text += ch;
        }
        //line.maxHeight = line.paint.fontDescent - line.paint.fontAscent;
        line.maxHeight = line.paint.fontSpacing;
        var (w, h) = line.paint.measureText(line.text);
        line.maxWidth = w;
        //logI(line.maxHeight);
        line.y = this._top;
        for (var l in this._lines)
            line.y += l.maxHeight;
        return line;
    }

    function _update()
    {
        this._lines = [];
        var lines = this._text.split("\n");
        for (var line in lines)
            this._lines.push(this._makeLine(line));
    }
}