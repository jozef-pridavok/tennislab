include "lib://core/exception.ms"

/**
    This class is base for all framework object.
    It provides basiv functionality of settings object attributes via options
    @abstract
*/
class BaseClass
{
    /**
        Construct of the object calls following method in order
        1.beforeInit
        2.init
        3.afterInit
        4._setOptions

        @param <object> options
    */
    function this(options = {})
    {
        this._options = options;
        this.beforeInit();
        this.init();
        this._setOptions();
        this.afterInit();
    }

    /**
        Method is executed before inititialiation of this object
        @abstract
        @protected
    */
    function beforeInit()
    {
        this._initialized = false;
    }

    /**
        Method is executed to initialize object
        @abstract
        @protected
    */
    function init()
    {
    }

    /**
        Method is executed after inititialization of this object
        @abstract
        @protected
    */
    function afterInit()
    {
        this._initialized = true;
    }

    property options(v)
    {
        get return this._options;
    }

    property initialized(v)
    {
        get return this._initialized;
    }

    /**
        Sets default controls options
        @params <object> v Default object from theme
    */
    property defaults(v)
    {
        get return this._defaults;
    }

    /**
        Undefined property handler is executed when property is undefined.
        It can be that JSON format is in format "key":"value".
        Key is an string, so if this is the case method return "value".
        As well as key is a regular property of the class it returns getter of this
        property

        @params <string> key
        @params <mixed> value
    */
    property undefined(k, v)
    {
        get {
            var ret;
            if (this[k] !== undefined)
               return this[k];
            else if(this[k.toString()] !== undefined)
               return this[k.toString()];
            else if(this.exists(k, false))
               return this.propertyAt(k)
           return undefined;
        }
    }

    /**
        Method is setting control's option variables.
        Options is present at the contstuct of the object after
        defaults are applied.
        @private
    */
    function _setOptions()
    {
        for (var p in this._options)
            this._setProperty(this, this._options, p);
    }

    /**
        Method is setting control's defaults variables set
        from current theme.
        @private
    */
    function _setDefaults(defaults)
    {
        this._defaults = defaults;
        for(var p in this._defaults)
            this._setProperty(this, this._defaults, p);
    }

    /**
        Method is parsing options and set properties to the control.
        Options is a JSON object.
        @private
    */
    function _setProperty(obj, data, p)
    {
        if (typeof p != #symbol) {
            assert false;
            return false;
        }

        //if (p == symbol("control")) {
        //    logI("data[p]", p, data[p], data.propertyAt(p), data.exists(p));
        //}

        if (typeof data[p] == #object && data[p] !== null) {
            // if current value is instance of Base class set it to current property
            if (data[p] instanceof BaseClass) {
                //logI("XXX", p);
                obj[symbol(p)] = data[p];
            } else {
                var o = obj.propertyAt(p);
                if (o == undefined) {
                    //o is not real object, to parse properties
                    //set object tu current property
                    obj[p] = data[p];
                } else {
                    for(var pp in data[p])
                        this._setProperty(o, data[p], pp);
                }
           }
           return true;
        }
        else if(typeof data[p] == #string)
            obj[p] = data[p].toString();
        else
            obj[p] = data[p];
    }


}