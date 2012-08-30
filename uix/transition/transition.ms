include "lib://core/baseClass.ms"
include "lib://core/animation/animator.ms"

/**
Base class for all scene `Form`. See see {{#crossLink "Form/activate"}}{{/crossLink}} of class {{#crossLink "Form"}}{{/crossLink}}.
This uses module This module uses {{#crossLinkModule "uix"}}{{/crossLinkModule}}.
@class Transition
*/
class Transition : BaseClass
{
    /**
    Init object parameters
    */
    function init()
    {
        super.init();
        this._duration = this.options.duration || 400; // milis
        this._transition = this.options.transition || Animator.Transition.easeInOut;
        this._objectFrom = this._objectTo = null;
    }

    /**
    @event
    */
    property onComplete(v)
    {
       get return this.doComplete;
        set {
             if (!(typeof v == #function || v == null))
                throw new InvalidArgument("[Transition.onComplete] Expects type of function");
             this.doComplete = v;
        }
    }

    property duration(v)
    {
        get return this._duration;
        set { this._duration = v; }
    }

    property transition(v)
    {
        get return this._transition;
        set { this._transition = v; }
    }

    /**
    @protected
    */
    property objectFrom(v)
    {
        get return this._objectFrom;
    }

    /**
    @protected
    */
    property objectTo(v)
    {
        get return this._objectTo;
    }

    /**
    @internal
    */
    function push(fromObject, toObject)
    {
        this._objectFrom = fromObject;
        this._objectTo = toObject;
        this._start();
    }

    /**
    @internal
    */
    function pop(fromObject, toObject)
    {
        this._objectFrom = fromObject;
        this._objectTo = toObject;
        this._start();
    }

    function setState(value)
    {
        // to be overwritten
    }

    /**
    @private
    */
    function _start()
    {
        var duration = this._duration;
        var transition = this._transition;
        this._animator = new Animator({duration: duration, transition: transition, onComplete:function() { this super.complete(); }});
        this._animator.addSubject(this)
        this._animator.play();
        this.start();
    }

    function start()
    {
        this._objectFrom.left = 0;
        this._objectFrom.top = 0;
        this._objectFrom.suspendDrawing();

        this._objectTo.left = 0;
        this._objectTo.top = 0;
        this._objectTo.suspendDrawing();
    }

    function complete()
    {
        if (typeof this.doComplete == #function)
            this.doComplete.apply(this);
        this._animator.dispose();
        this._animator = null;
        this._objectFrom.resumeDrawing();
        this._objectTo.resumeDrawing();
    }

    function draw(canvas)
    {
    }

}
