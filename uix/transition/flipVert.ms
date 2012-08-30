include "lib://uix/uiTransition.ms"

class FlipVert : UiTransition
{

    function init()
    {
        super.init();

        this._view3d = new View3D();
    }

    function start()
    {
        this._objectFrom.left = 0;
        this._objectTo.left = 0;

        this._view3d.translate(0, System.width / 2, 0);
    }

    /**
    @private
    */
    function setState(value)
    {
        super.setState(value);
        var rotating = Math.floor(value * 90);
        //this._view3d = new View3D();
        this._view3d.rotateY(rotating);
        Application.instance.invalidate();
        //this._objectFrom.left = sliding;
        //this._objectTo.left = -System.width + sliding;
    }

    /**
    @internal
    */
    function draw(canvas)
    {
        super.draw(canvas);
        this._view3d.applyToCanvas(canvas);
        return;
        if (this._objectFrom) {
            canvas.save();
            canvas.translate(this._x, 0);
            this._objectFrom.draw(canvas);
            canvas.restore();
        }
        if (this._objectTo) {
            canvas.save();
            canvas.translate(this._x - System.width, 0);
            this._objectTo.draw(canvas);
            canvas.restore();
        }
    }
}

