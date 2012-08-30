include "lib://core/animation/animator.ms"
include "lib://graphics/colorPaint.ms"
include "lib://uix/form.ms"
include "lib://uix/title/titleBar.ms"
include "lib://uix/tab/tabBar.ms"
include "lib://uix/transition/slideToRight.ms"
include "lib://uix/layout/fillLayout.ms"
include "app://accountLoginControl.ms"
include "app://accountRegisterControl.ms"

class AccountForm : Form
{
    var singleton = null;

    function create(options = {})
    {
        if (AccountForm.singleton == null)
            AccountForm.singleton = new AccountForm(options);
        return AccountForm.singleton;
    }

    function beforeInit()
    {
        super.beforeInit();
        assert AccountForm.singleton == null;
    }

    function init()
    {
        super.init();
        this._registerOrLogin = new TitleItem({text:"Register", onClick:::this super._switchControl()});
        this._titleBar = new TitleBar({
            name:"titleBar", text: "Login",
            leftItems: [new TitleItem({text:"Back", kind:#back, onClick:::Application.instance.pop(new SlideToRight())})],
            rightItems: [this._registerOrLogin],
        });
        this.add(this._titleBar);

        this._content = new Control({name:"content", layout:new FillLayout(), verticalLayout: {stretch: #both} });
        this._login = new AccountLoginControl();
        this._register = new AccountRegisterControl();
        this._content.add(this._login);
        this._content.add(this._register);

        this.add(this._content);
    }

    function afterInit()
    {
        super.afterInit();
        assert AccountForm.singleton == null;
        AccountForm.singleton = this;
        this._setCurrent(this._login);
        this.name = "accountForm";
    }

    function activate()
    {
        super.activate();
        this._login.activate();
        this._register.activate();
    }

    function keyReleased(key)
    {
        if (key == #back)
            Application.instance.pop(new SlideToRight());
    }

    function _setCurrent(control)
    {
        this._current = control;
        for (var c in this._content.native)
            c.top = c != control ? this._content.height : 0;
    }

    function _switchControl()
    {
        var content = this._content;
        var current = this._current;
        var isCurrentLogin = current == this._login;
        var target =  isCurrentLogin ? this._register : this._login;
        this._titleBar.text = isCurrentLogin ? "Register" : "Login";
        this._registerOrLogin.text = isCurrentLogin ? "Login" : "Register";
        this._titleBar.performLayout();
        target.top = content.height;
        var animator = new Animator({onComplete: function() { this super._setCurrent(target); }});
        animator.addSubject(function(state) {
            var step = Math.floor(content.height * state);
            target.top = content.height - step;
            current.top = -step;
        })
        animator.play();
    }

}