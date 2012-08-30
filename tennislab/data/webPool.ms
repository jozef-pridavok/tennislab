include "app://settings.ms"
// use custom secure config file
include "app://secure.ms"

/**
@class WebPool
*/
class WebPool
{

    /**
    @attribute pool
    @type Array
    @static
    */
    var pool = [];

    /**
    Creates web request according to specific resources. The data will be POSTed to the resource URL. Request is stored to local pool.
    @method request
    @param resource {String} The web service name;
    @param data {Object} The JSON object to be posted.
    @param onSuccess {Function} Callback function to be called when data posted successfuly.
    @param onError {Function} Error callback function.
    @static
    */
    function request(resource, data, onSuccess, onError = null)
    {
        var url = RES + resource + ".ashx";
        var wc = new WebClient();
        wc.open(HOST, PORT, false, ""); // host, port, secure, proxy
        wc.onReceived = function(sender) {
            assert typeof onError == #function;
            dlogI("[WebPool.received]", url, this.data.toString("utf8"));
            onSuccess(this.data);
        }
        wc.onError = function(sender)
        {
            dlogI("[WebPool.error]", url, this.error.errorMessage);
            if (typeof onError == #function)
                onError({code: this.errorCode, message: this.errorMessage});
        }
        var json = String.printf("%v", data);
        dlogI("[WebPool.request]", url, json);
        wc.postData(url, json);
        pool.push(wc);
        return wc;
    }

    /**
    Cancels all unfinished requests stored in local (static) web request's pool.
    @method cancelAll
    @static
    */
    function cancelAll()
    {
        for (var wc in pool) {
            if (wc == null)
                continue;
            wc.cancel();
            wc = null;
        }
        if (pool.length != 0)
            pool = [];
    }

}