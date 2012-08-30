include "app://data/webPool.ms"

class AdsWebService
{
    /**
    @static
    */
    function getListAds(pageIndex, onSuccess, onError, pageSize = 25)
    {
        //onSuccess([
        //    {"id": 1, "title":"Looking for experienced tennis pro", "applications": 2},
        //    {"id": 2, "title":"Looking for a tennis head", "applications": 3},
        //]);
        //return;
        var self = this;
        WebPool.request("ListAds", {session:Settings.session, pageIndex:0, pageSize:25},
            function(data) {
                if (typeof onSuccess != #function)
                    return;
                data = parseData(data.toString("utf8"));
                if (data["code"] > 0) {
                    onSuccess(data["ads"]);
                } else {
                    onError({code:data["code"], message:data["message"]});
                }
            },
            function(error) { // {code: int, message: string}
                if (typeof onError != #function)
                    return;
                onError(error);
            }
        );
    }

    function getListApplications(adId, pageIndex, onSuccess, onError, pageSize = 25)
    {
        //onSuccess([
        //    {"id": 1, "name":"Petra Bukari", "city":"NYC", "state":"new Yourk", "email":"oxy1977@gmail.com", "phone":"+421905736850", "describe":"Lorem ipsum", "bio": "Lorep ipsum", "resume":"Lorem impsum"},
        //    {"id": 2, "name":"Petra Bukari", "city":"NYC", "state":"new Yourk", "email":"oxy1977@gmail.com", "phone":"+421905736850", "describe":"Lorem ipsum", "bio": "Lorep ipsum", "resume":"Lorem impsum"},
        //    {"id": 3, "name":"Petra Bukari", "city":"NYC", "state":"new Yourk", "email":"oxy1977@gmail.com", "phone":"+421905736850", "describe":"Lorem ipsum", "bio": "Lorep ipsum", "resume":"Lorem impsum"},
        //]);
        //return;
        var self = this;
        WebPool.request("ListApplications", {session:Settings.session, pageIndex:0, pageSize:25, adId:adId},
            function(data) {
                if (typeof onSuccess != #function)
                    return;
                data = parseData(data.toString("utf8"));
                if (data["code"] > 0) {
                    onSuccess(data["contacts"]);
                } else {
                    onError({code:data["code"], message:data["message"]});
                }
            },
            function(error) { // {code: int, message: string}
                if (typeof onError != #function)
                    return;
                onError(error);
            }
        );
    }
}
