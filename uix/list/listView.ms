include "lib://uix/control.ms"
include "lib://uix/list/listItem.ms"
include "lib://uix/layout/verticalLayout.ms"
include "lib://uix/progress/wait.ms"

class ListView : Control
{
    function init()
    {
        super.init(Moscrif.ScrollView);

        //this._view = new Moscrif.ScrollView();
        this._view.width = System.width;
        this._view.height = System.height / 2;
        this._view.dockContent = #top;
        this._view.scrollMode = #vert;
        this._view.stretch = #both;

        this._layout = new VerticalLayout();
    }

    /**
    Adds new item to list view.
    @method add
    @param item {ListItem} An item to be added to list.
    @chainable
    */
    function add(item)
    {
        assert item instanceof ListItem;
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
        Application.skin.drawListView(canvas, this);
        if (this._wait)
            this._wait.draw(canvas);
    }

}
