include "lib://uix/control.ms"

/**
@class TitleItem
*/
class TitleItem : Control
{
    function init()
    {
        super.init();

        this._view.width = TitleItem.style.width;
        this._view.height = TitleItem.style.height;
    }

    /**
    @property text String|Bitmap|Path
    */
    property image(v)
    {
        get { return this._image; }
        set {
            if (this._image == v)
                return;
            this._image = v;
            if (this.initialisation)
                return;
            this.invalidate();
        }
    }

    /**
    @property text String
    */
    property text(v)
    {
        get { return this._text; }
        set {
            if (this._text == v)
                return;
            this._text = v;
            if (this.initialisation)
                return;
            var (w, h) = TitleItem.style.foreground.measureText(v);
            this.width = w + 2 * TitleItem.style.padding;
            this.invalidate();
        }
    }

    /**
    @property kind String
    */
    property kind(v)
    {
        get { return this._kind; }
        set {
            if (this._kind == v)
                return;
            assert v == null || v == #normal || v == #back;
            this._kind = v;
            if (this.initialisation)
                return;
            this.invalidate();
        }
    }

    function drawDefault(canvas)
    {
        Application.skin.drawTitleItem(canvas, this);
    }
}