include "lib://core/baseClass.ms"
include "lib://core/animation/animator.ms"

class Wait : BaseClass
{
    function init()
    {
        super.init();

        this._path = new Path();
        this._angle = 360;
        this._finalPosition = -25;

        this._createAnimators();
        this._createPaints();
    }

    function afterInit()
    {
        super.afterInit();
        this._w2 = this._width / 2;
        this._h2 = this._height / 2;
    }

    function dispose()
    {
        if (this._animator) {
            this._animator.stop();
            this._animator = null;
        }
        if (this._colorAnimator) {
            this._colorAnimator.stop();
            this._colorAnimator = null;
        }
    }

    property owner(v)
    {
        get return this._owner;
        set this._owner = v;
    }

    property width(v)
    {
        get return this._width;
        set {
            this._width = v;
            this._w2 = v / 2;
        }
    }

    property height(v)
    {
        get return this._height;
        set {
            this._height = v;
            this._h2 = v / 2;
        }
    }

    property x(v)
    {
        get return this._x;
        set this._x = v;
    }

    property y(v)
    {
        get return this._y;
        set this._y = v;
    }

    function _createPaints()
    {
        this._sliderPaint = new Paint();
        this._sliderPaint.style = #stroke;
        this._sliderPaint.strokeWidth = 5;
        this._sliderPaint.color = 0xffffffff;
        
        this._bgCirclePaint = new Paint();
        this._bgCirclePaint.style = #stroke;
        this._bgCirclePaint.strokeWidth = 5;
        this._bgCirclePaint.color = 0xffffffff;
        this._bgCirclePaint.alpha = 0;
        
        this._bgCircle = new Paint();
        this._bgCircle.style = #stroke;
        this._bgCircle.strokeWidth = 5;
        this._bgCircle.color = 0xff4c4c4c;
    }

    function _createAnimators()
    {
        this._animator = new Animator({
            duration : 750,
            transition: Animator.Transition.linear,
        });
        this._animator.addSubject(function(state)
        {
            this super._angle = ((state)*360).toInteger();
            this super._redraw();
        });
        this._animator.onComplete = function()
        {
            this super._finalPosition -= 165;
            //this super._angle = 360;
            this super._redraw();
            if (!this super._animator)
                return;
            this.reverse();
        }
        this._animator.reverse();

        this._colorAnimator = new Animator({
            duration : 750,
            transition: Animator.Transition.strongEasyIn,
        });
        this._colorAnimator.addSubject(function(state)
        {
            this super._bgCirclePaint.alpha = (state * 230).toInteger();
        });
        this._colorAnimator.onComplete = function()
        {
            //this super._bgCirclePaint.alpha = 0;
            if (!this super._colorAnimator)
                return;
            this.play();
        }
        this._colorAnimator.play();
    }

    function _redraw()
    {
        this._path.reset();
        this._path.arcTo(this._x - this._w2, this._y - this._h2, this._x + this._w2, this._y + this._h2, this._finalPosition - this._angle / 2, this._angle, true);
        this._owner.invalidate();
    }

    function draw(canvas)
    {
        //canvas.clear(0xff000000);
        canvas.drawOval(this._x - this._w2, this._y - this._h2, this._x + this._w2, this._y + this._h2, this._bgCircle);
        canvas.drawOval(this._x - this._w2, this._y - this._h2, this._x + this._w2, this._y + this._h2, this._bgCirclePaint);
        canvas.drawPath(this._path, this._sliderPaint);
    }
}