include "lib://uix/form.ms"
include "lib://uix/transition/slideToLeft.ms"
include "lib://uix/control/label.ms"

class AboutForm : Form
{
    var singleton = null;

    function create(options = {})
    {
        if (AboutForm.singleton == null)
            AboutForm.singleton = new AboutForm(options);
        AboutForm.singleton.job = options.job;
        return AboutForm.singleton;
    }

    function beforeInit()
    {
        super.beforeInit();
        assert AboutForm.singleton == null;
    }

    function init()
    {
        super.init();

        const padding = System.width/30;

        this.add(new TitleBar({
            text: "About", labelAlign:#screen,
            rightItems: [new TitleItem({text:"Done", onClick:::Application.instance.pop(new SlideToLeft())})]
        }));

        this.add(new Label({text:"Tennis Lab. The most efficient way to hire and get hired!", width:System.width/10*5, height:System.height/4, multiLine:true, padding:padding }));
        this.add(new Label({text:"Tennis lab was founded by a small group of people who see a significant gap in the social aspect of tennis teaching and tennis learning. For more info visit our website.", width:System.width/10*5, height:System.height/4, multiLine:true, padding:padding }));

        this._buttons = new Control({name:"buttons", stretch:true, padding:[System.width/50], layout:new VerticalLayout({space:System.width/40}) });
        this.add(this._buttons);

        this._buttons.add(new Button({text:"Visit tennislab.com", stretch:false, padding:[padding,0,padding,0], onClick:function() {this super._visit();} }));
        this._creditInfo = new Label({width:System.width/10*5, height:System.height/4, multiLine:true, padding:padding });
        this._buttons.add(this._creditInfo);

        this._wait = null;
    }

    function afterInit()
    {
        super.afterInit();
        assert AboutForm.singleton == null;
        AboutForm.singleton = this;
    }

    function activate()
    {
        super.activate();
        this._updateCreditInfo();
    }

    function keyReleased(key)
    {
        if (key == #back)
            Application.instance.pop(new SlideToLeft());
    }

    function draw(canvas)
    {
        if (this._wait)
            this._wait.draw(canvas);
    }

    function _updateCreditInfo()
    {
        this._creditInfo.text = String.printf("You have %d credits.", Settings.credits);
    }

    function _visit()
    {
        System.exec({command:"open-url", url:"http://tennislab.com"})
    }

    function _buy(credits)
    {
        var self = this;
        var size = System.width / 10;
        self._wait = new Wait({owner:this, width:size, height:size, x:this.width/2, y:this.height/2});
        function start() {
            self._buttons.visible = false;
            self.invalidate();
        }
        function stop() {
            self._buttons.visible = true;
            self._updateCreditInfo();
            self.invalidate();
            if (self._wait) {
                self._wait.dispose();
                self._wait = null;
            }
        }
        start();
        AccountWebService.charge(credits,
            function(credits) {
                Settings.credits = credits;
                Settings.save();
                stop();
            },
            function (error) {
                stop();
                handleError(error.code, error.message);
            }
        );
    }

}