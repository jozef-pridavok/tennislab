include "lib://uix/control.ms"
include "lib://uix/control/textBox.ms"
include "lib://uix/layout/verticalLayout.ms"
include "lib://uix/transition/slideToRight.ms"
include "app://adsForm.ms"
include "app://settings.ms"
include "app://data/accountWebService.ms"

class AccountLoginControl : Control
{
    function init()
    {
        super.init();

        this._paint = new Paint();
        this._paint.color = 0xffaa2233;

        const gap = System.width / 10;

        this._layout = new VerticalLayout({margin:gap, space:gap});

        this._email = new TextBox({text:Settings.login, hint:"your email address", onKey:function(key){ if (key == #enter) this super._login() } });
        this.add(this._email);

        this._password = new TextBox({text:"", password:true, hint:"your password", onKey:function(key){ if (key == #enter) this super._login() } });
        this.add(this._password);

        this._loginButton = new Button({text:"", onClick:function() {this super._login();} });
        this.add(this._loginButton);

        this._wait = null;
    }

    function afterInit()
    {
        super.afterInit();
        this.name = "accountLoginControl";
    }

    function activate()
    {
        this._loginButton.visible = true;
        this._updateLoginButton();
    }

    function draw(canvas)
    {
        if (this._wait)
            this._wait.draw(canvas);
    }

    function _updateLoginButton()
    {
        var loggedIn = Settings.session !== "";
        this._loginButton.text = loggedIn ? "Logout" : "Login";
    }

    function _login()
    {
        Application.instance.hideKeyboard();
        var loggedIn = Settings.session !== "";
        if (loggedIn) {
            Settings.accountType = 101;
            Settings.session = "";
            Settings.save();
            this._updateLoginButton();
            return;
        }
        var self = this;
        var size = System.width / 10;
        self._wait = new Wait({owner:this, width:size, height:size, x:this.width/2, y:this.height - size});
        function start() {
            self._loginButton.visible = false;
        }
        function stop() {
            self._loginButton.visible = true;
            if (self._wait) {
                self._wait.dispose();
                self._wait = null;
            }
        }
        start();
        // e1, 123456789 - employer
        // oxy1, oxy
        AccountWebService.login(this._email.text, this._password.text,
            function(session, credits, accountType) {
                stop();
                Settings.login = self._email.text;
                Settings.session = session;
                Settings.credits = credits;
                Settings.accountType = accountType;
                Settings.save();
                if (Settings.accountType == 100)
                    Application.instance.push(AdsForm.create({name:"AdsForm"}), new SlideToBottom());
                else
                    Application.instance.push(JobsForm.create({name:"JobsForm"}), new SlideToBottom());
                    //Application.instance.pop(new SlideToRight());
            },
            function (error) {
                stop();
                handleError(error.code, error.message);
                logI("ERROR", error.code, error.message);
            }
        );
    }
    
}