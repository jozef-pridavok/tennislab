include "lib://graphics/colorPaint.ms"
include "lib://uix/control.ms"
include "lib://uix/title/titleItem.ms"
include "lib://uix/layout/gridLayout.ms"
include "lib://uix/layout/flowLayout.ms"

class TitleBar : Control
{
    // @region Contruction

    function init()
    {
        super.init();

        this._view.width = TitleBar.style.width;
        this._view.height = TitleBar.style.height;

        this._view.stretch = #horz;

        this._view.onResize = function(sender, width, height)
        {
            this super._layout.performLayout(sender, sender);
        }

        this._layout = new GridLayout({rows: 1, columns: 3});

        this._leftItems = [];
        this._rightItems = [];
    }

    function afterInit()
    {
        super.afterInit();

        if (this._leftItems.length > 0)
            this._updatePane(#left);

        if (this._rightItems.length > 0)
            this._updatePane(#right);

        this.performLayout();
    }

    // @endregion

    // @region Properties

    property leftItems(v)
    {
        get return this._leftItems;
        set {
            this._leftItems = v;
            if (this.initialized)
                this._updatePane(#left);
        }
    }

    property rightItems(v)
    {
        get return this._rightItems;
        set {
            this._rightItems = v;
            if (this.initialized)
                this._updatePane(#right);
        }
    }

    property leftItemsCount(v)
    {
        get { return this._leftItems.length; }
    }

    property rightItemsCount(v)
    {
        get { return this._rightItems.length; }
    }

    // @endregion

    function add(item, side = #right)
    {
        assert item instanceof TitleItem || typeof item == #string || typeof item == #symbol : String.printf("typeof item = %s", typeof item);
        assert side == #left || side == #right;
        var pane = this._getPane(side);
        pane.add(this._createItem(pane, item), #front);
        //pane.performLayout();
        //var (mw, mh) = pane.layout.getPackedBounds(pane._view);
        //pane.width = 100;//mw;
    }

    function removeAll()
    {
        this._view.removeAll();
    }

    function drawDefault(canvas)
    {
        return Application.skin.drawTitleBar(canvas, this);
    }

    // @region implementation

    function _createItem(pane, item)
    {
        if (item instanceof TitleItem)
            ;
        else if (typeof item == #string)
            item = new TitleItem({text: item});
        else if (typeof item == #symbol)
            item = new TitleItem({text: "icon"});
        else
            assert false;
        item.height = pane.height - (2 * pane.layout.vertPadding);
        return item;
    }

    function _createPane(side)
    {
        var pane = new Control({name: side.toString() + "Pane", layout: new FlowLayout({vertPadding:this.height/8, horzPadding:this.height/8, horzAlign: side})});
        //pane.onDraw = function(canvas) {
        //    canvas.drawRect(0, 0, this.width, this.height, ColorPaint.stock().white);
        //}
        pane.gridLayout = {column: (side == #left ? 0 : 2) };
        return pane;
    }

    function _getPane(side)
    {
        if (side == #right) {
            if (this._right == null) {
                this._right = this._createPane(side);
                this._view.add(this._right);
                this.performLayout();
            }
            return this._right;
        }
        if (side == #left) {
            if (this._left == null) {
                this._left = this._createPane(side);
                this._view.add(this._left);
                this.performLayout();
            }
            return this._left;
        }
        assert false;
    }

    function _updatePane(side)
    {
        if (side == #right) {
            if (this._rightItems.length == 0 && this._right) {
                this._right.detach();
                this._right = null;
            }
            for (var i in this._rightItems)
                this.add(i, side);
        }
        if (side == #left) {
            if (this._leftItems.length == 0 && this._left) {
                this._left.detach();
                this._left = null;
            }
            for (var i in this._leftItems)
                this.add(i, side);
        }
    }

    // @endregion
}
