/**
Ecteption definition class.
@loaction uix/exception/exception.ms
*/
class Exception
{
    /**
    Construct of exception instance
    @param String|Excepion Error string or an instance of Exception
    @param Exception Instance of Exception
    */
    function this(arg1 = null, arg2 = null)
    {
        this._object = null;
        this._what = "";

        if (typeof arg1 == #string) {
            this._what = arg1;
            if (arg2 instanceof Exception)
                this._object = arg2;
            }
        else if (arg1 instanceof Exception)
            this._object = arg1;
    }

    /**
    Convert Exception to string
    */
    function toString()
    {
        if (this._object == null)
            return this.className + ": " + this._what;
        else
            return this.className + ": " + this._what + " (Cause " + this._object.toString() + ")";
    }
}

/**
Invalid Argument Exception
*/
class InvalidArgument : Exception {}

/**
Null pointer Exception
*/
class NullPointer : Exception {}

/**
Input/Oputput Exception
*/
class IOException : Exception {}