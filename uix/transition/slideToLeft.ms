include "lib://uix/transition/transition.ms"

class SlideToLeft : Transition
{

    function init()
    {
        super.init();
    }

    function start()
    {
        super.start();
        this._objectFrom.left = 0;
        this._objectTo.left = System.width;
    }

    function complete()
    {
        super.complete();
    }

    /**
    @private
    */
    function setState(value)
    {
        super.setState(value);
        var sliding = Math.floor(value * System.width);
        this._objectFrom.left = -sliding;
        this._objectTo.left = System.width - sliding;
    }
}

