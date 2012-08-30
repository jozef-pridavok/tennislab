include "lib://core/animation/animator.ms"

class Transition
{
    var defaultOptions = {
        transition: Animator.Transition.linear,
        duration: 400, // length of animation
    };

    function this(options)
    {
        this.setOptions(Transition.defaultOptions, options);
    }

    function setOptions(options)
    {
        this._options = Transition.applyDefaults(Transition.defaultOptions, options);
    }

    function to(obj, options, autoPlay = true)
    {
        var target;// = this._getTargetAttributes(options);
        var original; // = this._getOriginalAttributes(obj, options);
        function animation(state)
        {
            for (var prop in target) {
                if (typeof target[prop] == #function || typeof original[prop] == #function || typeof obj[prop] == #function)
                    continue;
                var isReal = typeof target[prop] == #float;
                var delta = target[prop] - original[prop];
                // json property
                if (obj[prop] !== undefined) {
                    obj[prop] = original[prop] + (isReal ? (state * delta) : Math.floor(state * delta));
                    continue;
                }
                // function's property
                var value = obj.propertyAt(prop);
                if (value === undefined) {
                    logW("Property", prop, "not found!");
                    continue;
                }
                value = original[prop] + (isReal ? (state * delta) : Math.floor(state * delta));
                obj[prop] = value;
            }
        }
        var animator = new Animator(options);
        animator.onComplete = function()
        {
            animator.dispose();
        }
        animator.onStart = function() {
            target = this super._getTargetAttributes(options);
            original = this super._getOriginalAttributes(obj, options);
        }
        animator.addSubject(animation)
        if (autoPlay)
            animator.play();
        return animator;
    }

    function from(obj, options, autoPlay = true)
    {
        var target; // = this._getTargetAttributes(options);
        var original; // = this._getOriginalAttributes(obj, options);
        // apply target
        for (var prop in target) {
            if (typeof target[prop] == #function || typeof original[prop] == #function || typeof obj[prop] == #function)
                continue;
            // json property
            if (obj[prop] !== undefined) {
                obj[prop] = target[prop];
                continue;
            }
            // function's property
            var value = obj.propertyAt(prop);
            if (value === undefined) {
                logW("Property", prop, "not found!");
                continue;
            }
            value = target[prop];
            obj[prop] = value;
        }
        function animation(state)
        {
            for (var prop in target) {
                if (typeof target[prop] == #function || original[prop] == #function || obj[prop] == #function)
                    continue;
                var isReal = typeof target[prop] == #float;
                var delta = target[prop] - original[prop];
                // json property
                if (obj[prop] !== undefined) {
                    obj[prop] = target[prop] - (isReal ? (state * delta) : Math.floor(state * delta));
                    continue;
                }
                // function's property
                var value = obj.propertyAt(prop);
                if (value === undefined) {
                    logW("Property", prop, "not found!");
                    continue;
                }
                value = target[prop] - (isReal ? (state * delta) : Math.floor(state * delta));
                obj[prop] = value;
            }
        }
        var animator = new Animator(options);
        animator.onComplete = function()
        {
            animator.dispose();
        }
        animator.onStart = function() {
            target = this super._getTargetAttributes(options);
            original = this super._getOriginalAttributes(obj, options);
        }
        animator.addSubject(animation)
        if (autoPlay)
            animator.play();
        return animator;
    }

    // @private
    function _getTargetAttributes(options)
    {
        return Transition._getCustom(Transition.defaultOptions, options);
    }

    // @private
    function _getOriginalAttributes(obj, options)
    {
        var target = Transition._getCustom(Transition.defaultOptions, options);
        var original = target.clone();
        for (var prop in original) {
            if (typeof target[prop] == #function || original[prop] == #function || obj[prop] == #function)
                continue;
            // json property
            if (obj[prop] !== undefined) {
                original[prop] = obj[prop];
                continue;
            }
            // function's property
            var value = obj.propertyAt(prop);
            if (value === undefined) {
                logW("Property", prop, "not found!");
                continue;
            }
            original[prop] = value;
        }
        return original;
    }

    // STATIC FUNCTIONS

    // @static
    // merge the properties of two objects
    function applyDefaults(defaults, prefs)
    {
        prefs = prefs || {};
        var prop, result = {};
        for (prop in defaults)
            result[prop] = prefs[prop] !== undefined ? prefs[prop] : defaults[prop];
        return result;
    }

    // @static
    // returns properties NOT included in defaults (all except defaults)
    function _getCustom(defaults, prefs)
    {
        var result = prefs.clone();
        for (var prop in Transition.defaultOptions)
            delete result[prop];
        return result;
    }
}
