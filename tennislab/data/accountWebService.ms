include "lib://core/baseClass.ms"
include "app://data/webPool.ms"

class AccountWebService : BaseClass
{

    /**
    @static
    */
    function autoLogin(session, onSuccess, onError)
    {
        WebPool.request("autologin", {session:session},
            function(data) {
                if (typeof onSuccess != #function)
                    return;
                data = parseData(data.toString("utf8"));
                var code = data["code"];
                if (code >= 0)
                    onSuccess(code);
                else
                    onError({code:data["code"], message:data["message"]});
            },
            function(error) {
                if (typeof onError != #function)
                    return;
                onError(error)
            }
        );
    }

    /**
    @static
    */
    function login(email, password, onSuccess, onError)
    {
        password = MD5.string(password + SALT).toHex();
        WebPool.request("login", {email:email, password:password},
            function(data) {
                if (typeof onSuccess != #function)
                    return;
                data = parseData(data.toString("utf8"));
                var code = data["code"];
                if (code >= 0)
                    onSuccess(data["message"], code, data["accountType"]);
                else
                    onError({code:data["code"], message:data["message"]});
            },
            function(error) {
                if (typeof onError != #function)
                    return;
                onError(error)
            }
        );
    }

    /**
    @static
    */
    function register(email, password, onSuccess, onError)
    {
        password = MD5.string(password + SALT).toHex();
        WebPool.request("registration", {email:email, name:email, password:password},
            function(data) {
                if (typeof onSuccess != #function)
                    return;
                data = parseData(data.toString("utf8"));
                var code = data["code"];
                if (code >= 0)
                    onSuccess(data["message"], code);
                else
                    onError({code:data["code"], message:data["message"]});
            },
            function(error) {
                if (typeof onError != #function)
                    return;
                onError(error)
            }
        );
    }

    /**
    @static
    */
    function charge(credits, onSuccess, onError)
    {
        WebPool.request("charge", {credits:credits, session:Settings.session},
            function(data) {
                if (typeof onSuccess != #function)
                    return;
                data = parseData(data.toString("utf8"));
                var code = data["code"];
                if (code >= 0)
                    onSuccess(code);
                else
                    onError({code:data["code"], message:data["message"]});
            },
            function(error) {
                if (typeof onError != #function)
                    return;
                onError(error)
            }
        );
    }

}