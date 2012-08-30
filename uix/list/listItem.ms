include "lib://uix/control.ms"

/**
@class ListItem
*/
class ListItem : Control
{
    // @region Initialization

    function init()
    {
        super.init();

        this._view.width = ListItem.style.width;
        this._view.height = ListItem.style.height;
        this._view.stretch = #horz;
        this._view.dockContent = #top;
        this._view.scrollMode = #vert;
    }

    // @endregion

    property onDraw(v)
    {
        get return this.draw;
        set {
            assert typeof(v) == #function || v == null;
            this.draw = v;
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
        Application.skin.drawListItem(canvas, this);
    }
}