include "lib://uix/control.ms"

/**
@class Button
*/
class Button : Control
{
    // @region Initialization

    function init()
    {
        super.init();

        this._view.width = this.options.width || Button.style.width;
        this._view.height = this.options.height || Button.style.height;
        this._view.stretch =  #none;
    }

    // @endregion

    property onDraw(v)
    {
        get return this.doDraw;
        set {
            assert typeof(v) == #function || v == null;
            this.doDraw = v;
        }
    }

    property _onClick(v)
    {
        get return this.doClick;
        set {
            assert typeof(v) == #function || v == null;
            this.doClick = v;
        }
    }

    function drawDefault(canvas)
    {
        Application.skin.drawButton(canvas, this);
    }
}