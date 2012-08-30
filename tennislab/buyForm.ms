include "lib://uix/form.ms"
include "lib://uix/transition/slideToBottom.ms"
include "lib://uix/control/label.ms"

class BuyForm : Form
{
    var singleton = null;

    var productIdentifiers = [
        "com.quellement.tennislab.2credits",
        "com.quellement.tennislab.15credits",
        "com.quellement.tennislab.45credits",
        "com.quellement.tennislab.145credits",
        "com.quellement.tennislab.400credits"
    ];

    var productCredits = [
        2,
        15,
        45,
        145,
        400,
    ];

    var productTexts = [
        "Buy 2 credits",
        "Buy 14 credits + 1 credit extra",
        "Buy 40 credits + 5 credits extra",
        "Buy 120 credits + 25 credits extra",
        "Buy 360 credits + 40 credits extra",
    ];

    function create(options = {})
    {
        if (BuyForm.singleton == null)
            BuyForm.singleton = new BuyForm(options);
        return BuyForm.singleton;
    }

    function beforeInit()
    {
        super.beforeInit();
        assert BuyForm.singleton == null;
    }

    function init()
    {
        super.init();

        const padding = System.width/30;

        this.add(new TitleBar({
            text: "Buy Credits",
            rightItems: [new TitleItem({text:"Done", onClick:::Application.instance.pop(new SlideToBottom())})]
        }));

        this._buttons = new Control({name:"buttons", stretch:true, padding:[System.width/50], layout:new VerticalLayout({space:System.width/40}) });
        this.add(this._buttons);

        var self = this;

        var size = System.width / 10;
        self._wait = new Wait({owner:this, width:size, height:size, x:this.width/2, y:this.height/2});
        function start() {
            self._buttons.visible = false;
            self.invalidate();
        }
        function stop(reason = #default) {
            if (reason == #notSupported) {
                self._buttons.add(new Label({text: "Purchases aren't supported!"}));
                self._buttons.add(new Button({text:"Visit tennislab.com", stretch:false, padding:[padding,0,padding,0], onClick:function() {self._visit();} }));
            }
            if (reason == #disabled) {
                self._buttons.add(new Label({text: "Purchases are disabled!"}));
            }
            self._buttons.visible = true;
            self.invalidate();
            if (self._wait) {
                self._wait.dispose();
                self._wait = null;
            }
        }
        start();


        if (System.OS_NAME == #iOS) {
            if (AppStore.isAvailable()) {
                this._store = new AppStore();
                this._store.requestProducts(productIdentifiers);
                this._store.onProductsRetrieved = function(valid, invalid) {
                    var ok;
                    ok = valid.filter(:x :x.productIdentifier == productIdentifiers[0]);
                    if (ok && ok.length == 1)
                        self._buttons.add(new Button({text:productTexts[0], stretch:false, padding:[padding,0,padding,0], onClick:function() {self._buy(0);} }));
                    ok = valid.filter(:x :x.productIdentifier == productIdentifiers[1]);
                    if (ok && ok.length == 1)
                        self._buttons.add(new Button({text:productTexts[1], stretch:false, padding:[padding,0,padding,0], onClick:function() {self._buy(1);} }));
                    ok = valid.filter(:x :x.productIdentifier == productIdentifiers[2]);
                    if (ok && ok.length == 1)
                        self._buttons.add(new Button({text:productTexts[2], stretch:false, padding:[padding,0,padding,0], onClick:function() {self._buy(2);} }));
                    ok = valid.filter(:x :x.productIdentifier == productIdentifiers[3]);
                    if (ok && ok.length == 1)
                        self._buttons.add(new Button({text:productTexts[3], stretch:false, padding:[padding,0,padding,0], onClick:function() {self._buy(3);} }));
                    ok = valid.filter(:x :x.productIdentifier == productIdentifiers[4]);
                    if (ok && ok.length == 1)
                        self._buttons.add(new Button({text:productTexts[4], stretch:false, padding:[padding,0,padding,0], onClick:function() {self._buy(4);} }));
                    //for (var v in invalid)
                    //    self._buttons.add(new Label({text:v}));
                    stop();
                }
            } else {
                stop(#disabled);
            }
        } else {
            stop(#notSupported);
            //to simulate
            /*
            var timer = new Timer(1, 1);
            timer.onTick = function() {
                var valid = [{productIdentifier: productIdentifiers[0]}, {productIdentifier: productIdentifiers[1]}, {productIdentifier: productIdentifiers[2]}, {productIdentifier: productIdentifiers[3]}, {productIdentifier: productIdentifiers[4]}];
                var ok;
                ok = valid.filter(:x :x.productIdentifier == productIdentifiers[0]);
                if (ok && ok.length == 1)
                    self._buttons.add(new Button({text:productTexts[0], stretch:false, padding:[padding,0,padding,0], onClick:function() {self._buy(0);} }));
                ok = valid.filter(:x :x.productIdentifier == productIdentifiers[1]);
                if (ok && ok.length == 1)
                    self._buttons.add(new Button({text:productTexts[1], stretch:false, padding:[padding,0,padding,0], onClick:function() {self._buy(1);} }));
                ok = valid.filter(:x :x.productIdentifier == productIdentifiers[2]);
                if (ok && ok.length == 1)
                    self._buttons.add(new Button({text:productTexts[2], stretch:false, padding:[padding,0,padding,0], onClick:function() {self._buy(2);} }));
                ok = valid.filter(:x :x.productIdentifier == productIdentifiers[3]);
                if (ok && ok.length == 1)
                    self._buttons.add(new Button({text:productTexts[3], stretch:false, padding:[padding,0,padding,0], onClick:function() {self._buy(3);} }));
                ok = valid.filter(:x :x.productIdentifier == productIdentifiers[4]);
                if (ok && ok.length == 1)
                    self._buttons.add(new Button({text:productTexts[4], stretch:false, padding:[padding,0,padding,0], onClick:function() {self._buy(4);} }));
                stop();
            }
            timer.start(1000);
            */
        }

        this._creditInfo = new Label({width:System.width/10*5, height:System.height/6, multiLine:true, padding:padding});
        this.add(self._creditInfo);
    }

    function afterInit()
    {
        super.afterInit();
        assert BuyForm.singleton == null;
        BuyForm.singleton = this;
    }

    function activate()
    {
        super.activate();
        this._updateCreditInfo();
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

    function _buy(index)
    {
        var credits = productCredits[index];
        var self = this;
        var size = System.width / 10;
        self._wait = new Wait({owner:this, width:size, height:size, x:this.width/2, y:this.height/2});
        function start() {
            self._buttons.visible = false;
            self.invalidate();
        }
        function stop(popForm = false) {
            self._buttons.visible = true;
            self._updateCreditInfo();
            self.invalidate();
            if (self._wait) {
                self._wait.dispose();
                self._wait = null;
            }
            if (popForm)
                Application.instance.pop(new SlideToBottom());
        }
        start();

        this._store.onTransactionCompleted = function(transaction) {
            self._store.finish(transaction);            
            AccountWebService.charge(credits,
                function(credits) {
                    Settings.credits = credits;
                    Settings.save();
                    stop(true);
                },
                function (error) {
                    stop(true);
                    handleError(error.code, error.message);
                }
            );
        }
        this._store.onTransactionFailed = function(transaction, errorCode, errorMessage) {
            self._store.finish(transaction);
            System.messageBox(errorMessage);
            stop();
        }

        this._store.purchase(productIdentifiers[index]);
    }

}