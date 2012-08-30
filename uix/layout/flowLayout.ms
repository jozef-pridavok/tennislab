include "lib://uix/layout/layout.ms"

// TODO: vertAlign not implemented
class FlowLayout : Layout
{
    function afterInit()
    {
        super.afterInit();
        this._vertPadding = this.options.vertPadding || 0;
        this._horzPadding = this.options.horzPadding || 0;
        this._vertAlign = this.options.vertAlign || #top;
        this._horzAlign = this.options.horzAlign || #left;
    }

    property vertPadding(v)
    {
        get return this._vertPadding;
        set this._vertPadding = v;
    }

    property horzPadding(v)
    {
        get return this._horzPadding;
        set this._horzPadding = v;
    }

    property vertAlign(v)
    {
        get return this._vertAlign;
        set {
            assert v == #top || v == #bottom;
            this._vertAlign = v;
        }
    }

    property horzAlign(v)
    {
        get return this._horzAlign;
        set {
            assert v == #left || v == #right;
            this._horzAlign = v;
        }
    }

    function performLayout(parent, children)
    {
        super.performLayout(parent, children);
        /* left & top only
            var curTopLine = this._vertPadding;
            var curLeftLine = this._horzPadding;
            var curBottomLine = 0;
            for (var child in children) {
                if (curLeftLine + child.width > parent.width) {
                    curTopLine = curBottomLine + this._vertPadding;
                    curLeftLine = this._horzPadding;
                }
                child.setPosition(curLeftLine, curTopLine);
                curLeftLine = curLeftLine + child.width + this._horzPadding;
                if (curBottomLine < curTopLine + child.height)
                    curBottomLine = curTopLine + child.height;
            }
        */
        var curTopLine = this._vertPadding;
        var curLeftLine = this._horzAlign == #left ? this._horzPadding : parent.width - this._horzPadding;
        var curBottomLine = this._vertAlign == #top ? 0 : parent.height - this._vertAlign;
        for (var child in children) {
            if (this._horzAlign == #left && curLeftLine + child.width > parent.width) {
                curTopLine = curBottomLine + this._vertPadding;
                curLeftLine = this._horzPadding;
            }
            if (this._horzAlign == #right && curLeftLine < this._horzPadding) {
                curTopLine = curBottomLine + this._vertPadding;
                curLeftLine = parent.width - this._horzPadding;
            }
            child.setPosition(curLeftLine - (this._horzAlign == #left ? 0 : child.width), curTopLine);
            curLeftLine = this._horzAlign == #left ? curLeftLine + child.width + this._horzPadding : curLeftLine - child.width - this._horzPadding;
            if (curBottomLine < curTopLine + child.height)
                curBottomLine = curTopLine + child.height;
        }
    }

    function getPackedBounds(children)
    {
        var left = Integer.MAX;
        var top = Integer.MAX;
        var right = Integer.MIN;
        var bottom = Integer.MIN;
        for (var child in children) {
            logI("child", child.name, child.width, child.height);
            if (child.left < left)
                left = child.left;
            if (child.top < top)
                top = child.top;
            if (child.right > right)
                right = child.right;
            if (child.bottom > bottom)
                bottom = child.bottom;
        }
        var width = (bottom - top) + 2 * this._vertPadding;
        var height = (right - left) + 2 * this._horzPadding;
        logI(">", width, height, left, top, right, bottom);
        return (width, height);
    }

}