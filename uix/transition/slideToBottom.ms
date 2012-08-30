include "lib://uix/transition/transition.ms"

class SlideToBottom : Transition
{

    function init()
    {
        super.init();
    }

    function start()
    {
        super.start();
        this._objectFrom.top = 0;
        this._objectTo.top = -System.height;
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
        var sliding = Math.floor(value * System.height);
        this._objectFrom.top = sliding;
        this._objectTo.top = -System.height + sliding;
    }

}

