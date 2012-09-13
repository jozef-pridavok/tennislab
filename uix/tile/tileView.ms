include "lib://uix/control.ms"
include "lib://uix/tile/tileItem.ms"
include "lib://uix/layout/verticalLayout.ms"
include "lib://uix/progress/wait.ms"

class TileView : Control
{
    function init()
    {
        super.init(Moscrif.ScrollView);

        this._view.width = System.width;
        this._view.height = System.height / 2;
        this._view.dockContent = #top;
        this._view.scrollMode = #vert;
        this._view.stretch = #both;

        this._layout = new GridLayout({rows:1, columns:2, vertSpace:5, horzSpace:5});
    }

    /**
    Adds new item to tile view.
    @method add
    @param item {TileItem} An item to be added to tileset.
    @chainable
    */
    function add(item)
    {
        assert item instanceof TileItem;

        var count = this._view.childrenCount;

        var column = count % this._layout.columns;
        var row = count / this._layout.columns;

        item.gridLayout = {row:row, column:column};

        if (row > this._layout.rows)
            this._layout.rows = row + 1;

        this._layout.height = this._layout.rows * TileItem.style.height;
        this._view.add(item, #front);

        this.performLayout();
    }

    function removeAll()
    {
        this._view.removeAll();
    }

    function beginWait()
    {
        if (this._wait)
            return;
        var size = System.width / 10;
        this._wait = new Wait({owner:this, width:size, height:size, x:this.width/2, y:this.height/2});
    }

    function endWait()
    {
        if (!this._wait)
            return;
        this._wait.dispose();
        this._wait = null;
    }

    function drawDefault(canvas)
    {
        Application.skin.drawTileView(canvas, this);
        if (this._wait)
            this._wait.draw(canvas);
    }

}
