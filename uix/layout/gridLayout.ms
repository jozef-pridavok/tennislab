include "lib://uix/layout/layout.ms"

/**
GridLayout.

@class GridLayout
*/
/**
@example
Child settings:
    gridLayout: {
        row: 0,
        column: 0,

    }
*/
class GridLayout : Layout
{
    function afterInit()
    {
        super.afterInit();
        this._vertSpace = this.options.vertSpace || 0;
        this._horzSpace = this.options.horzSpace || 0;
    }

    property rows(v)
    {
        get return this._rows;
        set this._rows = v;
    }

    property columns(v)
    {
        get return this._columns;
        set this._columns = v;
    }

    property vertSpace(v)
    {
        get return this._vertSpace;
        set this._vertSpace = v;
    }

    property horzSpace(v)
    {
        get return this._horzSpace;
        set this._horzSpace = v;
    }

    function performLayout(parent, children)
    {
        super.performLayout(parent, children);
        var rowSpace = parent.height / this._rows;
        var colSpace = parent.width / this._columns;
        for (var r = 0; r < this._rows; r++) {
            for (var c = 0; c < this._columns; c++) {
                for (var child in children) {
                    if (!child.gridLayout)
                        continue;
                    //logI("layout", child.text, child.gridLayout.row, child.gridLayout.column);
                    var cr = child.gridLayout.row || 0;
                    var ch = child.gridLayout.column || 0;
                    if (cr == r && ch == c) {
                        child.left = c * colSpace + this._horzSpace;
                        child.top = r * rowSpace + this._vertSpace;
                        child.width = colSpace - 2 * this._horzSpace;
                        child.height = rowSpace - 2 * this._vertSpace;
                    }
                }
            }
        }
    }

}