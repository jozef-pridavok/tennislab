include "app://data/webPool.ms"

/**
This class encapsulated Jobs service.
@class JobsWebService
*/
class JobsWebService
{
    /**
    Requests list of all available jobs on tennislab.com.
    @method getList
    @param pageIndex {Integer} The page index for a pagination.
    @param onSuccess {Function} Called when data are retrieved sucessfully.
    @param onError {Function} Called when data an error occured.
    @param [pageSize=25] {Integer} Size in number of records for a pagination.
    @static
    */
    function getList(pageIndex, onSuccess, onError, pageSize = 25)
    {
        var self = this;
        WebPool.request("ListJobs", {pageIndex:0, pageSize:25},
            function(data) {
                if (typeof onSuccess != #function)
                    return;
                data = parseData(data.toString("utf8"));
                if (data["code"] > 0)
                    onSuccess(data["jobs"]);
                else
                    onError({code:data["code"], message:data["message"]});
            },
            function(error) { // {code: int, message: string}
                if (typeof onError != #function)
                    return;
                onError({code:data["code"], message:data["message"]});
            }
        );
    }

    /**
    Requests application for specified job.
    @method apply
    @static
    */
    function apply(jobId, onSuccess, onError)
    {
        WebPool.request("applyJob", {jobId:jobId, session:Settings.session},
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
