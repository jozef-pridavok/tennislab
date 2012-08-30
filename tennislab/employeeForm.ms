include "lib://graphics/colorPaint.ms"
include "lib://uix/form.ms"
include "lib://uix/control/button.ms"
include "lib://uix/title/titleBar.ms"
include "lib://uix/transition/slideToRight.ms"
include "lib://uix/layout/flowLayout.ms"
include "lib://uix/web/webView.ms"
include "lib://uix/progress/wait.ms"
include "app://data/jobsWebService.ms"

class EmployeeForm : Form
{
    var singleton = null;
    var silverBoldPaint = ColorPaint.create(0xff9d9d9d);
    var silverPaint = ColorPaint.create(0xff9d9d9d);
    var blackPaint = ColorPaint.create(0xff000000);

    var space = System.width / 15;

    function create(options = {})
    {
        if (EmployeeForm.singleton == null) {
            EmployeeForm.singleton = new EmployeeForm(options);
            silverPaint.textSize = System.height / 25;
            silverPaint.typeface = Typeface.fromName("Ubuntu");
            silverBoldPaint.textSize = System.height / 25;
            silverBoldPaint.typeface = Typeface.fromName("Ubuntu", #bold);
            blackPaint.textSize = System.height / 25;
            blackPaint.typeface = Typeface.fromName("Ubuntu");
            JobForm.singleton = new JobForm(options);
        }
        EmployeeForm.singleton.contact = options.contact;
        return EmployeeForm.singleton;
    }

    function beforeInit()
    {
        super.beforeInit();
        assert EmployeeForm.singleton == null;
    }

    function init()
    {
        super.init();
        var rightItems = null;
        this._browser = null;
        if (System.OS_NAME !== #iOS) {
            this._browser = new TitleItem({name:"browser", text:"View", onClick:::this super._showInExternalBrowser(); });
            rightItems = [this._browser];
        }
        this.add(new TitleBar({name:"titleBar", text: "Contact",
            leftItems: [new TitleItem({text:"Back", kind:#back, onClick:::Application.instance.pop(new SlideToRight())})],
            rightItems: rightItems
        }));

        this._content = new Control({name:"content", layout:new FillLayout(), verticalLayout: {stretch: #both}});
        this._detail = new Control({name:"content", verticalLayout: {stretch: #both}, onDraw:function(canvas) { this super._drawDetail(canvas); }, onClick:function(x, y) {this super._clickDetail(x, y)} });
        this._content.add(this._detail);
        this._bio = new Control({name:"content", verticalLayout: {stretch: #both}, onDraw:function(canvas) { this super._drawBio(canvas); }});
        this._bioHTML = new WebView({left:space, top:4*space});
        this._bio._view.add(this._bioHTML);
        this._content.add(this._bio);
        this._resume = new Control({name:"content", verticalLayout: {stretch: #both}, onDraw:function(canvas) { this super._drawResume(canvas); }});
        this._resumeHTML = new WebView({left:space, top:4*space});
        this._resume._view.add(this._resumeHTML);
        this._content.add(this._resume);
        this.add(this._content);

        var tabDetail = new TabItem({text:"Contact", control:this._detail});
        var tabBio = new TabItem({text:"Bio", control:this._bio});
        var tabResume = new TabItem({text:"Resume", control:this._resume});
        this.add(new TabBar({
            name:"tabBar", items: [tabDetail, tabBio, tabResume],
            onTabChanged: function(item) { this super._onTabChanged(this, item); }
        }));

        this._wait = null;
    }

    function afterInit()
    {
        super.afterInit();
        assert EmployeeForm.singleton == null;
        EmployeeForm.singleton = this;

        this._bioHTML.width = this._bio.width - 2*space;
        this._bioHTML.height = this._bio.height - this._bioHTML.top;

        this._resumeHTML.width = this._resume.width - 2*space;
        this._resumeHTML.height = this._resume.height - this._resumeHTML.top;
    }

    function activate()
    {
        super.activate();
        //this._bioHTML.visible = true;
        //this._resumeHTML.visible = true;
        this._setCurrent(this._detail);
    }

    function deactivate()
    {
        super.deactivate();
        //this._bioHTML.visible = false;
        //this._resumeHTML.visible = false;
        this._setCurrent(this._detail);
    }

    function keyReleased(key)
    {
        logI("form", this.name,  key);
        if (key == #back)
            Application.instance.pop(new SlideToRight());
    }

    property contact(v)
    {
        get return this._contact;
        set {
            this._contact = v;
            this._detail.invalidate();
            this._bioHTML.html = this._contact["bio"];
            this._resumeHTML.html = this._contact["resume"];
        }
    }

    function _drawTextBox(canvas, text, left, top, right, bottom, paint)
    {
        //canvas.drawRect(left, top, right, bottom, ColorPaint.stock().red);
        canvas.drawTextBox(text, left, top, right, bottom, paint);
    }

    function _drawBasicInfo(canvas)
    {
        var fg = blackPaint;
        var l, r;
        canvas.drawBitmap(Res.img.employerLogo, space, space);
        l = 2 * space + Res.img.employerLogo.width;
        r = this.width - space;
        this._drawTextBox(canvas, this._contact["name"], l, space, r, 2 * space, fg);
        fg = silverPaint;
        this._drawTextBox(canvas, this._contact["city"] + ", " + this._contact["state"], l, 2 * space, r, 3 * space, fg);
        return (space, r, 4 * space);
    }

    function _drawDetail(canvas)
    {
        var fg = silverBoldPaint;
        var (l, r, y) = this._drawBasicInfo(canvas);
        var img, text;
        var piece = System.width / 30;

        text = this._contact["email"];
        img = Res.img.at;
        canvas.drawBitmap(img, l, y);
        canvas.drawText(text, l + img.width + piece, y - fg.fontTop - fg.fontDescent, fg);
        y+= img.height + piece;

        text = this._contact["phone"];
        img = Res.img.phone;
        canvas.drawBitmap(img, l, y);
        canvas.drawText(text, l + img.width + piece, y - fg.fontTop - fg.fontDescent, fg);
        y+= img.height + piece;

        fg = silverPaint;
        this._drawTextBox(canvas, this._contact["describe"], l, y, r, this._detail.height, fg);
    }

    function _clickDetail(x, y)
    {
        //var piece = System.width / 15;
        if (y > 4*space && y < 4*space + Res.img.phone.height)
            System.exec({command:"mail-to", to:this._contact["email"]});
        else if (y > 4*space + Res.img.phone.height && y < 5*space + Res.img.phone.height)
            System.exec({command:"call-to", phone:this._contact["phone"]});
    }

    function _drawBio(canvas)
    {
        this._drawBasicInfo(canvas);
    }

    function _drawResume(canvas)
    {
        this._drawBasicInfo(canvas);
    }

    function _setCurrent(control)
    {
        this._current = control;
        for (var c in this._content.native)
            //c.top = c != control ? this._content.height : 0;
            c.left = c != control ? this._content.width : 0;
        if (this._browser)
            this._browser.visible = this._current == this._bio || this._current == this._resume;
    }

    function _onTabChanged(tabBar, item)
    {
        if (this._current === item.control)
            return;
        if (item.control == null)
            return;
        var content = this._content;
        var current = this._current;
        var target = item.control;
        //target.top = content.height;
        target.left = content.width;
        var animator = new Animator({onComplete: function() { this super._setCurrent(target); }});
        animator.addSubject(function(state) {
            //var step = Math.floor(content.height * state);
            //target.top = content.height - step;
            //current.top = -step;
            var step = Math.floor(content.width * state);
            target.left = content.width - step;
            current.left = -step;
        })
        animator.play();
    }

    function _showInExternalBrowser()
    {
        var args = (this._current == this._bio ? "bio" : "resume");
        System.exec({command:"open-url", url:"http://tennislab.com/mobile/" + args + ".aspx?id=" + this._contact["id"].toString() + "&session=" + Settings.session});
    }
}