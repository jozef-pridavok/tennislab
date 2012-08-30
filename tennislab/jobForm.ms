include "lib://uix/form.ms"
include "lib://uix/control/button.ms"
include "lib://uix/title/titleBar.ms"
include "lib://uix/transition/slideToRight.ms"
include "lib://uix/layout/flowLayout.ms"
include "lib://graphics/colorPaint.ms"
include "lib://uix/progress/wait.ms"
include "app://data/jobsWebService.ms"
include "app://buyForm.ms"

class JobForm : Form
{
    var singleton = null;
    var silverPaint = ColorPaint.create(0xff9d9d9d);
    var blackPaint = ColorPaint.create(0xff000000);

    function create(options = {})
    {
        if (JobForm.singleton == null) {
            silverPaint.textSize = System.height / 25;
            silverPaint.typeface = Typeface.fromName("Ubuntu");
            blackPaint.textSize = System.height / 25;
            blackPaint.typeface = Typeface.fromName("Ubuntu", #bold);
            JobForm.singleton = new JobForm(options);
        }
        JobForm.singleton.job = options.job;
        return JobForm.singleton;
    }

    function beforeInit()
    {
        super.beforeInit();
        assert JobForm.singleton == null;
    }

    function init()
    {
        super.init();
        this.add(new TitleBar({
            text: "Job",
            leftItems: [new TitleItem({text:"Back", kind:#back, onClick:::Application.instance.pop(new SlideToRight())})],
            rightItems: [new TitleItem({text:"Apply", onClick:::Application.instance.pop(new SlideToRight())})]
        }));

        this._detail = new Control({name:"detail", onDraw:function(canvas) { this super._drawDetail(canvas); }, stretch:true });
        this.add(this._detail);

        var style = JobForm.style;
        var piece = System.width / 15;
        this._scrollContent = new Moscrif.View();
        this._scrollContent.left = this._scrollContent.top = 0;
        this._scrollContent.height = 1000;
        this._scrollContent.onDraw = function(sender, canvas) {
            //canvas.drawRect(0, 0, this.width, this.height, new Paint());
            canvas.drawTextBox(this super._job["description"], 0, 0, this.width, this.height, style.description.native);
        }

        this._scroll = new Moscrif.ScrollView();
        this._scroll.dockContent = #left-top;
        this._scroll.scrollMode = #vert;
        this._scroll.left = 2 * piece + Res.img.employerLogo.width;
        this._scroll.top = 5 * piece;
        this._scroll.width = this._scrollContent.width = System.width - (3 * piece + Res.img.employerLogo.width);
        this._scroll.height = 6 * (System.height / 15);
        this._scroll.add(this._scrollContent);
        this._detail.add(this._scroll);

        this._account = new Control({name:"account", onDraw:function(canvas) { this super._drawAccount(canvas); }, stretch:false, height:Res.img.dollar.height });
        this.add(this._account);

        this._buttons = new Control({name:"buttons", onDraw:function(canvas) { this super._drawButtons(canvas); }, height:Button.style.height, padding:[System.width/50], layout:new VerticalLayout() });
        this.add(this._buttons);

        this._buttonApplyOrBuy = new Button({stretch:true, onClick:function() {this super._applyOrBuy();} });
        this._buttons.add(this._buttonApplyOrBuy);

        this._wait = null;
    }

    function afterInit()
    {
        super.afterInit();
        assert JobForm.singleton == null;
        JobForm.singleton = this;
    }

    function activate()
    {
        super.activate();
        this._updateApplyOrBuyButton();
    }

    function keyReleased(key)
    {
        logI("form", this.name,  key);
        if (key == #back)
            Application.instance.pop(new SlideToRight());
    }

    property job(v)
    {
        get return this._job;
        set {
            this._job = v;
            this.update();
        }
    }

    function update()
    {
        this._detail.invalidate();
        this._scrollContent.invalidate();
    }

    function _updateApplyOrBuyButton()
    {
        if (Settings.credits >= 2)
            this._buttonApplyOrBuy.text = "Apply";
        else
            this._buttonApplyOrBuy.text = "Buy";
        this._account.invalidate();
    }

    function _drawTextBox(canvas, text, left, top, right, bottom, paint)
    {
        //canvas.drawRect(left, top, right, bottom, ColorPaint.stock().red);
        canvas.drawTextBox(text, left, top, right, bottom, paint);
    }

    function _drawDetail(canvas)
    {
        //canvas.drawRect(0, 0, this._detail.width, this._detail.height, ColorPaint.stock().red);
        var style = JobForm.style;
        var piece = System.width / 15;
        var l, t, r, b;
        canvas.drawBitmap(Res.img.employerLogo, piece, piece);
        //canvas.drawRect(piece, piece, 4 * piece, 4 * piece, ColorPaint.stock().black);
        l = 2 * piece + Res.img.employerLogo.width;
        r = this.width - piece;
        this._drawTextBox(canvas, this._job["title"], l, piece, r, 3 * piece, style.title.native);
        this._drawTextBox(canvas, this._job["city"], l, 3 * piece, r, 4 * piece, style.description.native);

        //this._drawTextBox(canvas, this._job["description"], l, 5 * piece, r, 20 * piece, style.description.native);
    }

    function _drawAccount(canvas)
    {
        var w = this._account.width / 8;
        var h = this._account.height / 3;
        var text, tw, th;

        canvas.drawBitmap(Res.img.dollar, w*4 - Res.img.dollar.width / 2, 0);

        text = "Cost";
        (tw, th) = silverPaint.measureText(text);
        canvas.drawText(text, 2*w - tw/2, h, silverPaint);
        text = "2 credits";
        (tw, th) = blackPaint.measureText(text);
        canvas.drawText(text, 2*w - tw/2, 2*h, blackPaint);

        text = "Remaining";
        (tw, th) = silverPaint.measureText(text);
        canvas.drawText(text, 6*w - tw/2, h, silverPaint);
        text = String.printf("%d credits", Settings.credits);
        (tw, th) = blackPaint.measureText(text);
        canvas.drawText(text, 6*w - tw/2, 2*h, blackPaint);
    }

    function _drawButtons(canvas)
    {
        if (this._wait)
            this._wait.draw(canvas);
    }

    function _applyOrBuy()
    {
        if (Settings.credits >= 2)
            this._apply();
        else
            this._buy();
    }

    function _apply()
    {
        var self = this;
        var size = System.width / 10;
        self._wait = new Wait({owner:this._buttons, width:size, height:size, x:this._buttons.width/2, y:this._buttons.height/2});
        function start() {
            self._buttonApplyOrBuy.visible = false;
            self._buttons.invalidate();
        }
        function stop() {
            self._buttonApplyOrBuy.visible = true;
            self._buttons.invalidate();
            if (self._wait) {
                self._wait.dispose();
                self._wait = null;
            }
        }
        start();
        JobsWebService.apply(this._job["id"],
            function(credits) {
                stop();
                Settings.credits = credits;
                Settings.save();
                self._updateApplyOrBuyButton();
                System.messageBox(Res.txt.applied);
            },
            function (error) {
                stop();
                if (error.code == -1) {
                    handleError(0, "You've already aplied for this job!");
                } else {
                    handleError(error.code, error.message);
                }
            }
        );
    }

    function _buy()
    {
        Application.instance.push(BuyForm.create({name: "BuyForm"}), new SlideToTop());
        /*
        var self = this;
        var size = System.width / 10;
        self._wait = new Wait({owner:this._buttons, width:size, height:size, x:this._buttons.width/2, y:this._buttons.height/2});
        function start() {
            self._buttonApplyOrBuy.visible = false;
            self._buttons.invalidate();
        }
        function stop() {
            self._buttonApplyOrBuy.visible = true;
            self._buttons.invalidate();
            if (self._wait) {
                self._wait.dispose();
                self._wait = null;
            }
        }
        start();
        AccountWebService.charge(4,
            function(credits) {
                stop();
                Settings.credits = credits;
                Settings.save();
                self._updateApplyOrBuyButton();
                //System.messageBox(Res.txt.applied);
            },
            function (error) {
                stop();
                handleError(error.code, error.message);
            }
        );
        */
    }

}