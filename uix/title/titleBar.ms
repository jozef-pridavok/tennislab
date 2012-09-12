include "lib://graphics/colorPaint.ms"
include "lib://uix/control.ms"
include "lib://uix/title/titleItem.ms"
include "lib://uix/layout/gridLayout.ms"
include "lib://uix/layout/flowLayout.ms"
include "lib://uix/skin.ms"

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

        this._layout = new TitleBarLayout({owner: this});

        this._leftItems = [];
        this._rightItems = [];
    }

    function afterInit()
    {
        super.afterInit();

        if (this._leftItems.length > 0)
            this._updateItems(#left);

        if (this._rightItems.length > 0)
            this._updateItems(#right);

        //this.native.add(new Label({name:"title", text:this.options.text, side:#title}));

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
                this._updateItems(#left);
        }
    }

    property rightItems(v)
    {
        get return this._rightItems;
        set {
            this._rightItems = v;
            if (this.initialized)
                this._updateItems(#right);
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

    // @region Layout

    class TitleBarLayout : Layout
    {
        function init()
        {
            this._owner = this.options.titleBar;
        }
    
        function afterInit()
        {
            super.afterInit();
            this._padding = this.options.padding || TitleBar.style.padding;
        }
    
        property padding(v)
        {
            get return this._padding;
            set this._padding = v;
        }
    
        function performLayout(parent, children)
        {
            super.performLayout(parent, children);
            var leftItems = [];
            var rightItems = [];
            var label = null
            for (var child in children) {
                if (child.side == #left)
                    leftItems.push(child);
                if (child.side == #right)
                    rightItems.push(child);
                if (child.side == #title)
                    label = child;
            }
            var labelStart = 0;
            var labelEnd = 0;
            var x = this._padding;
            for (var child in leftItems) {
                child.setPosition(x, this._padding);
                child.height = parent.height - 2 * this._padding;
                x += child.width + this._padding;
            }
            labelStart = x;
            x = parent.width - this._padding;
            for (var child in rightItems) {
                child.setPosition(x - child.width, this._padding);
                child.height = parent.height - 2 * this._padding;
                x -= child.width + this._padding;
            }
            labelEnd = x;
            if (label) {
                label.setPosition(labelStart, this._padding);
                label.setSize(labelEnd - labelStart, parent.height - 2 * this._padding);
            }
        }
    }
    // @endregion

    function add(item, side)
    {
        assert item instanceof TitleItem || typeof item == #string || typeof item == #symbol : String.printf("typeof item = %s", typeof item);
        assert side == #left || side == #right;
        this.native.add(this._createItem(item, side), #front);
        this.performLayout();
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

    function _createItem(item, side)
    {
        if (item instanceof TitleItem)
            ;
        else if (typeof item == #string)
            item = new TitleItem({text: item});
        else if (typeof item == #symbol)
            item = new TitleItem({text: "icon"});
        else
            assert false;
        item.side = side;
        //item.height = pane.height - (2 * pane.layout.vertPadding);
        return item;
    }

    function _updateItems(side)
    {
        this.suspendLayout();
        if (side == #right) {
            for (var i in this._rightItems)
                this.add(i, side);
        }
        if (side == #left) {
            for (var i in this._leftItems)
                this.add(i, side);
        }
        this.resumeLayout(false);
    }

    function labelLimits()
    {
        var left = 0, right = this.width;
        for (var i in this._leftItems) {
            var cr = i.left + i.width + this._layout.padding;
            if (cr > left)
                left = cr;
        }
        for (var i in this._rightItems) {
            var cl = i.left - this._layout.padding;
            if (cl < right)
                right = cl;
        }
        return (left, right);
    }

    // @endregion
}