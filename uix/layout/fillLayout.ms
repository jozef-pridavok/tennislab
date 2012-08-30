include "lib://uix/layout/layout.ms"

class FillLayout : Layout
{
    function afterInit()
    {
        super.afterInit();
        this._padding = this.options.vertPadding || 0;
    }

    property padding(v)
    {
        get return this._horzPadding;
        set this._horzPadding = v;
    }

    function performLayout(parent, children)
    {
        super.performLayout(parent, children);
        for (var child in children) {
            child.setPosition(this._padding, this._padding);
            child.setSize(parent.width - 2*this._padding, parent.height - 2*this._padding);
        }
    }

}