include "lib://uix/layout/layout.ms"

/**
Child settings:
    verticalLayout: {
        dock: [#left, #top, #right, #bottom, #fill, #vert, #horz],
        padding: [left, top, right, bottom]
    }
@class VerticalLayout
*/
class VerticalLayout : Layout
{
    function afterInit()
    {
        super.afterInit();
        this._margin = this.options.margin || 0;
        this._space = this.options.space || 0;
    }

    property margin(v)
    {
        get return this._margin;
        set this._margin = v;
    }

    property space(v)
    {
        get return this._space;
        set this._space = v;
    }

    function performLayout(parent, children)
    {
        super.performLayout(parent, children);
        var stretches = 0;
        var eatenHeight = 0;
        for (var child in children) {
            if (this._canStretch(child))
                stretches++;
            else eatenHeight += child.height;
        }
        var restForStretch = parent.height - eatenHeight;
        var restForOneChild = restForStretch / (stretches == 0 ? 1 : stretches);
        var curTopLine = this._margin;
        for (var child in children) {
            var settings = child.verticalLayout;
            var padding = child.padding || settings.padding || [0, 0, 0, 0];
            if (typeof padding == #array && padding.length == 1)
                padding = [padding[0], padding[0], padding[0], padding[0]];
            if (typeof padding == #integer)
                padding = [padding, padding, padding, padding];
            child.setPosition(this._margin + padding[0], curTopLine + padding[1]);
            var height = child.height;
            if (this._canStretch(child))
                height = restForOneChild;
            child.setSize(parent.width - 2 * this._margin - (padding[0] + padding[2]), height - (padding[1] + padding[3]));
            curTopLine += height + this._space;
        }
    }

    function _canStretch(child)
    {
        var stretch = child.stretch || (child.verticalLayout || {}).stretch;
        return stretch === true || stretch === #vert || /*stretch === #horz ||*/ stretch === #both;
    }

}