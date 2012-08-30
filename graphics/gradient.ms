include "lib://core/baseClass.ms"

class Gradient : BaseClass
{
    function init()
    {
        this._paint = new Paint();
    }

    function afterInit()
    {
        super.afterInit();
        this._buildShader();
    }

    property native(v)
    {
        get return this._paint;
    }

    property points(v)
    {
        get return this._points;
        set this._points = v;
    }

    property colors(v)
    {
        get return this._colors;
        set this._colors = v;
    }

    property positions(v)
    {
        get return this._pos;
        set this._pos = v;
    }

    property kind(v)
    {
        get return this._kind;
        set {
            if (this._kind === v)
                return;
            assert v == #linear || v == #sweep;
            this._kind = v;
            if (!this.initialised)
                return;
            this._buildShader();
        }
    }

    function _buildShader()
    {
        if (this._kind == #linear) {
            this._buildLinearShader();
            return;
        }
        else if (this._kind == #sweep) {
            this._buildLinearShader();
            return;
        }
        else {
            assert false;
        }
    }

    function _buildLinearShader()
    {
        var shader = Shader.linear(this._points, this._colors, this._pos, null);
        this._paint.shader = shader;
    }

}