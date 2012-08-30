include "lib://uix/control.ms"
include "lib://uix/transition/slideToRight.ms"

class AccountRegisterControl : Control
{
    function init()
    {
        super.init();

        this._paint = new Paint();
        this._paint.color = 0xff0000ff;

        const gap = System.width / 10;

        this._layout = new VerticalLayout({margin:gap, space:gap});

        this._email = new TextBox({text:"", hint:"your email address", onKey:function(key){ if (key == #enter) this super._register() }});
        this.add(this._email);

        this._password = new TextBox({text:"", password:true, hint:"your password", onKey:function(key){ if (key == #enter) this super._register() }});
        this.add(this._password);

        this._password2 = new TextBox({text:"", password:true, hint:"password again", onKey:function(key){ if (key == #enter) this super._register() }});
        this.add(this._password2);

        this._buttonRegister = new Button({text:"Register", onClick:function() {this super._register();} });
        this.add(this._buttonRegister);

        this._wait = null;
    }

    function afterInit()
    {
        super.afterInit();
        this.name = "accountRegisterControl";
    }

    function activate()
    {
        this._buttonRegister.visible = true;
    }

    function draw(canvas)
    {
        if (this._wait)
            this._wait.draw(canvas);
    }

    function _register()
    {
        if (!this._email.text.match(/@/)) {
            System.messageBox("Invalid email address!");
            return;
        }
        if (this._password.text != this._password2.text) {
            System.messageBox("Password does not match!");
            return;
        }
        Application.instance.hideKeyboard();
        var self = this;
        var size = System.width / 10;
        self._wait = new Wait({owner:this, width:size, height:size, x:this.width/2, y:this.height - size});
        function start() {
            self._buttonRegister.visible = false;
        }
        function stop() {
            self._buttonRegister.visible = true;
            if (self._wait) {
                self._wait.dispose();
                self._wait = null;
            }
        }
        start();
        AccountWebService.register(this._email.text, this._password.text,
            function(session, credits) {
                stop();
                Settings.session = session;
                Settings.credits = credits;
                Settings.save();
                Application.instance.pop(new SlideToRight());
            },
            function (error) {
                stop();
                handleError(error.code, error.message);
            }
        );
    }

}