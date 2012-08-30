include "lib://uix/control.ms"
include "lib://uix/tab/tabItem.ms"
include "lib://uix/layout/gridLayout.ms"
include "lib://uix/layout/flowLayout.ms"

class TabBar : Control
{
    // @region Contruction

    function init()
    {
        super.init();

        this._view.width = System.width;
        this._view.height = System.height / 10;
        this._view.stretch = #horz;

        this._layout = new GridLayout({rows: 1, columns: 3});

        this._items = [];
    }

    function afterInit()
    {
        super.afterInit();

        if (this._items.length > 0)
            this._update();

        this.performLayout();
    }

    // @endregion

    // @region Properties

    property items(v)
    {
        get return this._items;
        set {
            this._items = v;
            if (this.initialized)
                this._update();
        }
    }

    // @endregion

    // @region Events

    /**
    @event
    @param item TabItem
    */
    property onTabChanged(v)
    {
        get return this.doTabChanged;
        set {
            assert typeof(v) == #function || v == null;
            this.doTabChanged = v;
        }
    }

    // @endregion

    function add(item)
    {
        assert item instanceof TabItem || typeof item == #string || typeof item == #symbol : String.printf("typeof item = %s", typeof item);
        this.suspendLayout();
        item = this._createItem(item);
        var lastIndex = this._view.childrenCount;
        this._layout.columns = lastIndex + 1;
        item.gridLayout = {row:0, column:lastIndex};
        this._view.add(item);
        //logI("adding", item.text);
        this.resumeLayout();
    }

    function removeAll()
    {
        this._view.removeAll();
    }

    function drawDefault(canvas)
    {
        return Application.skin.drawTabBar(canvas, this);
    }

    // @region implementation

    function _createItem(item)
    {
        var result = null;
        if (item instanceof TabItem)
            result = item;
        if (typeof item == #string)
            result = new TabItem({text: item});
        if (typeof item == #symbol)
            result = new TabItem({text: "icon"});
        assert result != null;
        result.onClick = function() { this super._handleItemClick(this); }
        return result;
    }

    function _handleItemClick(item)
    {
        if (typeof this.doTabChanged == #function)
            this.doTabChanged.call(this, item);
    }

    function _update()
    {
        this.suspendLayout();
        this._view.removeAll();
        for (var i in this._items)
            this.add(i);
        this.resumeLayout();
    }

    // @endregion
}
