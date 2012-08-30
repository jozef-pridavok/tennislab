include "lib://uix/control.ms"
include "lib://uix/layout/verticalLayout.ms"

/**
Form class
@class Form
*/
class Form : Control
{

    function init()
    {
        super.init();

        this._view.width = System.width;
        this._view.height = System.height;
        this._view.stretch = #both;

        this._layout = new VerticalLayout();

        /*
        this._layout = new Moscrif.StackLayout();
        this._layout.dockContnet = #start;
        this._layout.orientation = #vert;
        this._layout.align = #stretch;
        this._view.layout = this._layout;
        */
    }

    function afterInit()
    {
        super.afterInit();
        this.performLayout();
    }

    /**
        Make controls availaible as property of current form.
        @example

            var form = new form();
            form.add(new Label({name:"label1"}));
            form.add(new Label({name:"label2"}));

            form.label1.text = "Text 1";
            form.label2.text = "Text 2";

        @param <String> k key
        @param <Multivalue> v value

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
            if(this.isControl(k))
               ret = this.getControlByName(k);
            else
               ret = undefined;

            return ret;
        }
    }
    */

    property onActivate(v)
    {
        get return this.doActivate;
        set {
            assert typeof(v) == #function || v == null;
            this.doActivate = v;
        }
    }

    /**
    Override activates
    @method activate
    */
    function activate()
    {
        if (typeof this.doActivate == #function)
            this.doActivate();
        //this._view.visible = true;
    }

    property onDeactivate(v)
    {
        get return this.doDeactivate;
        set {
            assert typeof(v) == #function || v == null;
             this.doDeactivate = v;
        }
    }

    function deactivate()
    {
        //this._view.visible = false;
        if (typeof this.doDeactivate == #function)
            this.doDeactivate();
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
    */

    function keyReleased(key)
    {
    }

    function drawDefault(canvas)
    {
        Application.skin.drawForm(canvas, this);
    }

    function add(control)
    {
        assert control instanceof Control || control instanceof ListView || control instanceof TitleBar || control instanceof TabBar;
        this._view.add(control, #front);
    }

}

