include "lib://core/baseClass.ms"
include "lib://uix/skin.ms"
include "lib://uix/transition/transition.ms"

function onError(exp)
{
    console << exp ? exp.toString() : "(null)" << "\n";
}

/**
Provides the User Interface for application.

@module uix
**/

/**
Main application object
@class Application
@since 2012q2
@example
    class MyApp : Application
    {
    }
*/
class Application : BaseClass
{
    /**
    @static
    @attribute instance
    */
    var instance;

    function beforeInit()
    {
        super.beforeInit();
        assert Application.instance == null;
    }

    /**
    @class Application
    @constructor
    @param {object} [options=null] optional options.
    */
    function init()
    {
        super.init();

        this._transition = null;

        this._window = new Moscrif.Window();
        this._window.top = this._window.left = 0;
        this._window.width = System.width;
        this._window.height = System.height;
        this._window.onStart = function(sender)
        {
            var self = this super;
            if (typeof self.start == #function)
                self.start.call(self);
        }
        /*
        this._window.onQuit = function(sender)
        {
            var self = this super;
            if (typeof self.quit == #function)
                self.quit.call(self);
        }
        */
        this._window.onProcess = function(sender)
        {
            var self = this super;
            if (typeof self.process == #function)
                self.process.call(self);
            return self._terminate ? 0 : 1;
        }
        this._window.onDraw = function(sender, canvas)
        {
            var self = this super;
            if (typeof self.draw == #function)
                self.draw.call(self, canvas);
            else
                self.drawDefault(canvas);
        }
        this._window.onBeforeDraw = function(sender, canvas)
        {
            var self = this super;
            if (self._transition)
                self._transition.draw(canvas);
        }

        this._window.onKeyReleased = function(sender, key)
        {
            var self = this super;
            var form = self._forms.length > 0 ? self._forms[self._forms.length - 1] : null;
            if (form)
                form.keyReleased(key);
            return true;
        }

        /*
        this._layout = new Moscrif.StackLayout();
        this._layout.dockContnet = #start;
        this._layout.orientation = #vert;
        this._layout.align = #stretch;
        this._window.layout = this._layout;
        */

        this._forms = [];
    }

    function afterInit()
    {
        super.afterInit();
        assert Application.instance == null;
        Application.instance = this;

        if (!Application.skin)
            Application.skin = new Skin();
    }

    /**
    Gets currently allowed orientation for the application. Set allowed orientations.
    @property orientation
    @type Symbol
    */
    property orientation(v)
    {
        get return this._window.orientation;
        set this._window.orientation = v;
    }

    /* Make form instace accesible via application instance
        If propery is undefined it looks for name of the form stored in application.
        In the case form with same name as requested property is stored in application it returns instance of the form
    property undefined(k,v)
    {
        get {
logI(k, v);
            var ret;
            if(this[k] !== undefined)
               ret = this[k];
            else if(this[k.toString()] !== undefined)
               ret = this[k.toString()];
            else if(this.exists(k, false))
               ret = this.propertyAt(k)
            else if(this.isForm(k))
               ret = this._getFormByName(k);
            else
               ret = false;

            return ret;
        }
    }
    */

    /**
    Fires when application starts
    @event onStart
    */
    property onStart(v)
    {
        get return this.start;
        set {
            assert typeof(v) == #function || v == null;
            this.start = v;
        }
    }

    /*
    property onQuit(v)
    {
        get return this.quit;
        set {
            assert typeof(v) == #function || v == null;
            this.quit = v;
        }
    }
    */

    property onProcess(v)
    {
        get return this.process;
        set {
            assert typeof(v) == #function || v == null;
            this.process = v;
        }
    }

    /**
    Function push new form on the form stack of the appliction.
    @method push
    @param {Form} form a new form
    @param {SceneTransition} [transition=100] a transition to be used for animtion
    */
    function push(form, transition = null)
    {
        assert form instanceof Form;
        if (transition)
            this._setTransition(transition);
        var previousForm = this._forms.length ? this._forms[this._forms.length - 1] : null;
        if (previousForm)
            previousForm.deactivate();
        if (this._window.find(form.name) == null)
            this._window.add(form);
        form.activate();
        this._forms.push(form);
        if (transition)
            transition.push(previousForm, form);
        else {
            if (previousForm)
                previousForm.left = System.width;
            form.left = 0;
        }
    }

    /**
    Function push existing form from the form stack of the appliction.
    @method pop
    @param {SceneTransition} [transition=null] a transition to be used
    */
    function pop(transition = null)
    {
        if (transition)
            this._setTransition(transition);
        var currentForm = this._forms.length ? this._forms[this._forms.length - 1] : null;
        if (currentForm) {
            currentForm.deactivate();
        } else {
            this.quit();
            return;
        }
        this._forms.pop();
        var previousForm = this._forms.length ? this._forms[this._forms.length - 1] : null;
        if (previousForm) {
            previousForm.activate();
        } else {
            this.quit();
            return;
        }
        if (transition)
            transition.pop(currentForm, previousForm);
    }

    function requestKeyboard(callback, keyboardType = #default)
    {
        if (System.IS_EMULATOR === true) {
            /*
            this.keyboard.top = System.height - this.keyboard.height;
            this.keyboard.keyboardType = keyboardType;
            this.keyboard.visible = true;
            this.keyboard.invalidate();
            this.keyboard.onKey = function(sender,key)
            {
                callback(key);
            }
            */
        } else {
            System.requestKeyboard(function(sender, key) { callback(key) }, keyboardType);
        }
    }

    function hideKeyboard()
    {
        if (System.IS_EMULATOR === true)
            ; //this.keyboard.visible = false;
        else
            System.hideKeyboard();
    }

    /**
    Runs main application loop.
    @method run
    @param {bool} [allowFPS=false] indicated if FPS
    */
    function run(allowFPS = false)
    {
        this._window.init(allowFPS);
        this._window.run();
        return this;
    }

    function quit()
    {
        this._terminate = true;
    }

    function drawDefault(canvas)
    {
        canvas.clear(0xffffffff);
        //return Application.skin.drawApplication(canvas, this);
    }

    function invalidate()
    {
        this._window.invalidate();
    }

    function _setTransition(transition)
    {
        this._transition = transition;
        this._transition.onComplete = function() {
            this super._transition = null;
        }
    }

}