//global switch to enable/disable logging
var enableLogging = true;

/**
Log with severity level Info (Log-I)
*/
function log(x..)
{
    logI(x);
}

/**
Log with severity level Info (Log-I)
*/
function logI(x..)
{
    _log("Log-I", x);
}

/**
Log with severity warning Info (Log-W)
*/

function logW(x..)
{
    _log("Log-W", x);
}

/**
Log with severity level Error (Log-E)
*/

function logE(x..)
{
    _log("Log-E", x);
}

function logRI(ret, x..)
{
    _log("Log-I", x);
    return ret;
}

function logRW(ret, x..)
{
    _log("Log-W", x);
    return ret;
}

function logRE(ret, x..)
{
    _log("Log-E", x);
    return ret;
}

function dlogI(x..)
{
    if (System.IS_DEBUG)
        logI(x);
}

function dlogW(x..)
{
    if (System.IS_DEBUG)
        logW(x);
}

function dlogE(x..)
{
    if (System.IS_DEBUG)
        logE(x);
}

/**
Class to log duration
*/
class LogDuration
{
    /**
    Constructor
    */
    function this(x..)
    {
        this.start(x);
    }

    /**
    Start point
    @param Array x..
    */
    function start(x..)
    {
        this._start = System.tick;
        this._args = x;
        logI(x);
    }

    /**
    End of logging
    */
    function end()
    {
        logI(this._args, "Elapsed time: ", System.tick - this._start, "milis");
        this._start = 0;
        this._args = null;
    }
}

function logM(category, message..)
{
    if (!System.IS_DEBUG)
        return;
    console << "Log-M:\t" << category << "\t";
    for(var i = 0; i < message.length; i++)
        console << message[i];
    console << "\n";
}

function logGC(message)
{
    if (!System.IS_DEBUG)
        return;
    console << "Log-GC:\t";
    console << message;
    console << "\n";
}


/**
Loging all passed arguments with severity level

@param String severity
@parem Any x
*/
function _log(severity, x)
{
    if (!enableLogging)
        return;
    var date = new Date();
    console.printf("%s:\t%02d:%02d.%03d\t", severity, date.minute, date.second, date.millisecond);
    const sep = " ";
    var i, len = x.length;
    if (!len) return;
    function dumpView(o)
    {
        console << "name=" << o.name << (o.visible ? " (visible)" : " (hidden)") << ", left=" << o.left << ", top=" << o.top << ", width=" << o.width << ", height=" << o.height;
    }
    function dump(o)
    {
        var t = typeof o;
        if (o === null) console << "null";
        else if (o === undefined) console << "undefined";
        else if (o === nothing) console << "nothing";
        else if (t == #object) { console << ">>> "; o.show(); }
        else if (o instanceof Moscrif.View) { console << o << ", "; dumpView(o); }
        else console << o;
        return console;
    }
    for(i = 0; i < len - 1; i++) {
        dump(x[i]) << sep;
    }
    dump(x[len - 1]) << "\n\n";
}

/*
function xml_log(severity, x)
{
    //debug stacktrace;
    //throw "Stop";
    var date = new Date();
    console.printf("<%s timestamp=\"%02d:%02d.%03d\">\n", severity, date.minute, date.second, date.millisecond);
    const sep = " ";
    var i, len = x.length;
    if (!len) return;
    function dump(o)
    {
        if (o == null) console << "null";
        else if ((typeof o) == #object) o.show();
        else console << o;
        return console;
    }
    for(i = 0; i < len - 1; i++) {
        dump(x[i]) << sep;
    }
    dump(x[len - 1]) << "\n</" << severity << ">\n";
}
*/
