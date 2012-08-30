include "lib://core/baseClass.ms"
include "lib://uix/layout/layout.ms"

/**
@class ListItem
*/
class Control : BaseClass
{
    // @region Initialization

    function beforeInit()
    {
        super.beforeInit();
        this.suspendLayout();
    }

    function init(NativeView = Moscrif.View)
    {
        super.init();

        this._view = new NativeView();
        this._view.width = 100;
        this._view.height = 100;

        // @region Handlers
        this._view.onDraw = function(sender, canvas)
        {
            var self = this super;
            if (typeof self.draw == #function)
                self.draw.call(self, canvas);
            else
                self.drawDefault(canvas);
        }
        this._view.onProcess = function(sender)
        {
            var self = this super;
            if (typeof self.process == #function)
                self.process.call(self);
        }
        /*
        this._view.onKeyReleased = function(sender, key)
        {
            var self = this super;
            self.show();
            logI("Control", key, self.keyReleased);
            if (typeof self.keyReleased == #function)
                //self.keyReleased.call(self, key);
                self.keyReleased(key);
        }
        */
        // @endregion

        this._layout = null;
        this._layoutSuspended = false;
    }

    function afterInit()
    {
        //this.performLayout();
        super.afterInit();
        this.resumeLayout(false);
    }

    // @endregion

    // @region Properties

    /**
    @property native Moscrif.View
    */
    property native(v)
    {
        get { return this._view; }
    }

    /**
    @property name String
    */
    property name(v)
    {
        get return this._view.name;
        set this._view.name = v;
    }

    /**
    @property visible Boolean
    */
    property visible(v)
    {
        get return this._view.visible;
        set this._view.visible = v;
    }

    /**
    @property text String
    */
    property text(v)
    {
        get { return this._text; }
        set {
            if (this._text == v)
                return;
            this._text = v;
            if (this.initialisation)
                return;
            this.invalidate();
        }
    }

    /**
    X - coordinates of Control's position
    @param Integer v
    @return Integer
    */
    property left(v)
    {
        get return this._view.left;
        set {
            this._view.left = v;
        }
    }

    /**
    Y - coordinates of control's position
    @param Integer v
    @return Integer
    */
    property top(v)
    {
        get return this._view.top;
        set {
            this._view.top = v;
        }
    }

    /**
    Width of the Control (in pixels).
    @param Integer v
    @return Integer
    */
    property width(v)
    {
        get return this._view.width;
        set {
            this._view.width = v;
            this.performLayout();
            this.invalidate();
        }
    }

    /**
    Height of the Control (in pixels).
    @param Integer v
    @return Integer
    */
    property height(v)
    {
        get return this._view.height;
        set {
            this._view.height = v;
            this.performLayout();
            this.invalidate();
        }
    }

    property right(v)
    {
        get return this._view.left + this._view.width;
    }

    property bottom(v)
    {
        get return this._view.top + this._view.height;
    }

    property layout(v)
    {
        get return this._layout;
        set {
            if (this._layout === v)
                return;
            assert v instanceof Layout || v === null;
            this._layout = v;
        }
    }

    property layoutSuspended(v)
    {
        get return this._layoutSuspended;
    }

    property pressed(v)
    {
        get return this._pressed;
    }

    property onDraw(v)
    {
        get return this.draw;
        set {
            assert typeof(v) == #function || v == null;
            this.draw = v;
        }
    }

    property onProcess(v)
    {
        get return this.process;
        set {
            assert typeof(v) == #function || v == null;
            this.process = v;
        }
    }

    /*
    property onKeyReleased(v)
    {
        get return this.keyReleased;
        set {
            assert typeof(v) == #function || v == null;
            this.keyReleased = v;
        }
    }

    function _keyReleased(key)
    {
    }
    */

    property onClick(v)
    {
        get return this.doClick;
        set {
            assert typeof(v) == #function || v == null;
            this.doClick = v;

            this._pressed = false;
            this._pressPossible = false;
    
            // @region Handlers
            this._view.onPointerPressed = function(sender, x, y)
            {
                this super._pressPossible = true;
            }
            //
            this._view.onPointerReleased = function(sender, x, y)
            {
                var self = this super;
                if (!self._pressPossible)
                    return;
    
                self._pressed = true;
                self.invalidate();
    
                var deselect = new Timer(25, false);
                deselect.onTick = function(sender) {
                    self._pressPossible = self._pressed = false;
                    self.invalidate();
                    deselect.dispose();
                    if (typeof self.doClick == #function)
                        self.doClick.call(self, x, y);
                }
                deselect.start(40);
    
            }
            this._view.onParentScroll = function(sender, parent)
            {
                this super._pressPossible = false;
            }
            // @endregion
        }
    }

    // @endregion

    function setPosition(left, top)
    {
        this._view.left = left;
        this._view.top = top;
    }

    function setSize(width, height)
    {
        this._view.width = width;
        this._view.height = height;
        this.performLayout();
        this.invalidate();
    }

    function invalidate()
    {
        this._view.invalidate();
    }

    function suspendDrawing()
    {
        this._view.suspendDrawing();
    }

    function resumeDrawing()
    {
        this._view.resumeDrawing();
    }

    function performLayout(performForChildren = true)
    {
        if (!this._layout || this._layoutSuspended)
            return;
        this._layout.performLayout(this, this._view);
        if (performForChildren)
            for(var child in this._view)
                child.performLayout(performForChildren);
    }

    function suspendLayout()
    {
        this._layoutSuspended = true;
    }

    function resumeLayout(performNow = false, performForChildren = true)
    {
        this._layoutSuspended = false;
        if (performNow)
            this.performLayout(performForChildren);
    }

    function add(view, pos = #front)
    {
        this._view.add(view, pos);
        this.performLayout();
    }

    function drawDefault(canvas)
    {
        return Application.skin.drawControl(canvas, this);
    }
}