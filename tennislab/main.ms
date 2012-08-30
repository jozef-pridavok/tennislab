include "lib://core/log.ms"
include "lib://uix/application.ms"
include "lib://uix/transition/slideToBottom.ms"
include "app://topSpinSkin.ms"
include "app://resources.ms"
include "app://settings.ms"
include "app://jobsForm.ms"
include "app://adsForm.ms"
include "app://data/accountWebService.ms"
include "app://data/jobsWebService.ms"
include "app://data/adsWebService.ms"

function handleError(errorCode, errorMassage)
{
    if (errorCode < 0)
        System.messageBox(Res.txt.errors[-errorCode]);
    else
        System.messageBox(errorMassage);
}

class TopSpinJobs : Application
{
    function init()
    {
        super.init();
        // apply custom skin
        Application.skin = new TopSpinSkin();
    }

    function start()
    {
        // load resources and application settings
        Res.load();
        Settings.load();

        // push initial form
        this.push(JobsForm.create({name:"JobsForm"}));

        // autologin
        if (Settings.session != "")
            AccountWebService.autoLogin(Settings.session,
                function(credits) {
                    Settings.credits = credits;
                    Settings.save();
                    // if employer, switch to his fomr
                    if (Settings.accountType == 100)
                        this super.push(AdsForm.create({name:"AdsForm"}), new SlideToBottom());
                },
                function (error) {
                    Settings.session = "";
                    Settings.save();
                    handleError(error.code, error.message);
                }
            );
    }
}

new TopSpinJobs().run();