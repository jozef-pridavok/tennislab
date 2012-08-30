include "lib://core/baseClass.ms"

class Background : BaseClass
{
    function init()
    {
        this._paint = new Paint();
    }

    property native(v)
    {
        get return this._paint;
    }

    property color(v)
    {
        get return this._paint.color;
        set {
            this._paint.color = v;
        }
    }

    property alpha(v)
    {
        get return this._paint.alpha;
        set {
            this._paint.alpha = v;
        }
    }

    property antiAlias(v)
    {
        get return this._paint.antiAlias;
        set {
            this._paint.antiAlias = v;
        }
    }

    property style(v)
    {
        get return this._paint.style;
        set {
         this._paint.style = v;
        }
    }

    property strokeWidth(v)
    {
        get return this._paint.strokeWidth;
        set {
            this._paint.strokeWidth = v;
        }
    }

    property strokeCap(v)
    {
        get return this._paint.strokeCap;
        set {
            this._paint.strokeCap = v;
        }
    }

    property strokeJoin(v)
    {
        get return this._paint.strokeJoin;
        set {
            this._paint.strokeJoin = v;
        }
    }

    property filterBitmap(v)
    {
        get return this._paint.filterBitmap;
        set {
            this._paint.filterBitmap = v;
        }
    }

    property shader(v)
    {
        get return this._paint.shader;
        set {
            this._paint.shader = v;
        }
    }

    property maskFilter(v)
    {
       get return this._paint.maskFilter;
        set {
            this._paint.maskFilter = v;
        }
    }

    property colorFilter(v)
    {
        get return this._paint.colorFilter;
        set {
            this._paint.colorFilter = v;
        }
    }
}