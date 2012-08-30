include "lib://uix/control.ms"

/**
@class TabItem
*/
class TabItem : Control
{
    function init()
    {
        super.init();
        this._view.width = System.width / 3;
        this._view.height = System.height / 12;
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
            this.invalidate();
        }
    }

    function drawDefault(canvas)
    {
        Application.skin.drawTabItem(canvas, this);
    }
}