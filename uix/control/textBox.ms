include "lib://uix/control.ms"

class TextBox : Control
{

    function init()
    {
        super.init(Moscrif.ScrollView);

        this._editor = new Moscrif.TextView();
        this._editor.focusable = true;
        this._editor.readOnly = false;
        this._editor.vertAlign = #middle;
        this._editor.autoSize = #width;
        this._editor.left = this._editor.top = 0;
        this._editor.width = 100;
        this._editor.height = 100;
        this._editor.paint = TextBox.style.foreground.native
        this._editor.marginX = this._editor.marginY = System.width / 50;
        //this._editor.onDraw = function(s, c) {
        //    c.drawRect(0, 0, s.width, s.height, new Paint());
        //}

        this._editor.onChar = function (sender, charCode)
        {
            this super._acceptChar(charCode);
        }

        this._editor.onKeyPressed = function(sender, key)
        {
            this super._processKey(key);
        }

        this._view.onPointerPressed = function(sender, x, y)
        {
            this super._editor.setFocus();
            if (x > this super._editor.width)
                this super._editor.doCursorKey(#end);
        }

        this._editor.onFocusChanged = function(sender, gainFocus)
        {
            var self = this super;
            if (self._autoKeyboard) {
                if (gainFocus)
                    Application.instance.requestKeyboard(
                        function (key){
                            self._processKey(key)
                        }
                    );
                else
                    Application.instance.hideKeyboard();
            }

            self._doFocusChanged(sender, gainFocus);
            self.invalidate();
            if (typeof self.doFocusChanged == #function)
                self.doFocusChanged.call(self, gainFocus);
        }

        this._editor.onDrawCursor = function(sender, canvas, left, top, right, bottom)
        {
            Application.skin.drawTextBoxCursor(canvas, this super);
        }

        this._editor.onCursorChanged = function(sender, pos, line, char)
        {
            this super._doCursorChanged(sender, pos, line, char);
        }

        this._view.focusable = false;
        this._view.dockContent = #left-top;
        this._view.scrollMode = #horz;
        this.horzAlign = #left;
        this._password = this.options.password || false;
        this._autoKeyboard = this.options.autoKeyboard || true;
        this._lastPasswordChar = 0;

        this.add(this._editor);
    }

    /*
    property text(v)
    {
        get return (this._isEmpty ? "" : this._editor.text);
        set {
            this._editor.text = (v == "") ? this._hint : v;
            this._isEmpty = (this._editor.text == "") ? true : false;
        }
    }
    */
    property text(v)
    {
        get return (this._isEmpty ? "" : this._text);
        set {
            this._text = v;
            this._isEmpty = (v == "") ? true : false;
            if (this._password)
                this._editor.text = (v == "") ? this._hint : v.replace(/./g, "•");
            else
                this._editor.text = (v == "") ? this._hint : v;
        }
    }

    property hint(v)
    {
        get return this._hint;
        set {
            this._hint = v;
            if (this._isEmpty) {
                this._editor.text = this._hint;
            }
        }
    }

    property password(v)
    {
        get return this._password;
        set {
            this._password = v;
        }
    }

    property multiLine(v)
    {
        get return this._editor.multiLine;
        set
        {
          if(v) this.native.scrollMode = #vert;
          this._editor.multiLine = v;
        }
    }

    property readOnly(v)
    {
        get return this._editor.readOnly;
        set this._editor.readOnly = v;
    }

    property autoSize(v)
    {
        get return this._editor.autoSize;
        set this._editor.autoSize;
    }

    property autoKeyboard(v)
    {
        get return this._autoKeyboard;
        set this._autoKeyboard;
    }

    property vertAlign(v)
    {
        get return this._editor.vertAlign;
        set {
            this._editor.vertAlign = v;
            this._editor.invalidate();
        }
    }

    property horzAlign(v)
    {
        get return this._horzAlign;
        set {
            switch (v) {
                case #right:
                     this._view.dockContent = this.multiLine ? #right-top : #right;
                     this._horzAlign = #right;
                break;
                case #left:
                     this._view.dockContent = this.multiLine ? #left-top : #left;
                     this._horzAlign = #left;
                break;
            }
            this._editor.invalidate();
        }
    }

    property marginX(v)
    {
        get return this._editor.marginX;
        set this._editor.marginX = v
    }

    property marginY(v)
    {
        get return this._editor.marginY;
        set this._editor.marginY = v;
    }

    property editor(v)
    {
        get return this._editor;
    }

    property onFocusChanged(v)
    {
        get return this.doFocusChanged;
        set {
            assert typeof(v) == #function || v == null;
            this.doFocusChanged = v;
        }
    }

    property onChanged(v)
    {
        get return this.doChanged;
        set {
            assert typeof(v) == #function || v == null;
            this.doFocusChanged = v;
        }
    }

    property onKey(v)
    {
        get return this.doKey;
        set {
            assert typeof(v) == #function || v == null;
            this.doKey = v;
        }
    }

    function process()
    {
        if (this._password && this._lastPasswordChar) {
            if (System.tick - this._lastPasswordChar > 800) {
                this._editor.text = this._text.replace(/./g, "•");
                this._lastPasswordChar = 0;
            }
        }
    }

    function drawDefault(canvas)
    {
        Application.skin.drawTextBox(canvas, this);
    }

    function doResize(sender,w, h)
    {
         //set width
        if(this.autoSize != #width)
            this._editor.width = w;

        //set height
        if(this.autoSize != #height)
            this._editor.height = h;
    }

    function _acceptChar(keyCode)
    {
        if (this._password)
            this._lastPasswordChar = System.tick;
        var oldText = this._text;
        this._editor.text = this._text;
        this._editor.insert(keyCode);
        this._text = this._editor.text;
        if (this._password) {
            this._editor.text = this._text.substr(0, this._text.length - 1).replace(/./g, "•") + String.fromCharCode(keyCode);
            this._editor.invalidate();
        }
        if (oldText != this._text) {
            if (typeof this.doChanged == #function)
                this.doChanged.call(this, this._text);
            this._isEmpty = false;
        }
    }

    function _processKey(key)
    {
        if (typeof this.doKey == #function) {
            this.doKey.call(this, key);
        }
        var res;
        switch (key) {
            case #space:
                key = " ";
                break;
            case #left:
            case #right:
            case #up:
            case #down:
            case #home:
            case #end:
            case #enter:
                return this._editor.doCursorKey(key);
            case #backspace:
                this._editor.text = this._text;
                res = this._editor.backspace();
                this._text = this._editor.text;
                if (this._password) {
                    this._editor.text = this._text.replace(/./g, "•");
                    this._editor.invalidate();
                }
                return res;
        }
        if (typeof key == #string) {
            if (this._password) {
                this._lastPasswordChar = System.tick;
                key = key.charCodeAt(0);
                this._editor.text = this._text;
                this._editor.insert(key);
                this._text = this._editor.text;
                this._editor.text = this._text.replace(/./g, "•");
                this._editor.invalidate();
                this._isEmpty = false;
            } else {
                key = key.charCodeAt(0);
                this._editor.insert(key);
                this._text = this._editor.text;
            }
        }
    }

    function _doFocusChanged(sender, gainFocus)
    {
        if (gainFocus) {
            if (this._isEmpty) {
                this._text = "";
                this._editor.text = "";
                this._editor.invalidate();
                this._editor.width = 2 * this.marginX;
                this._view.performLayout();
            }
        } else {
            this._isEmpty = (this._editor.text == "" ? true:false);
            if (this._isEmpty) {
                this._editor.text = this._hint;
                this._editor.invalidate();
            }
        }
        this.invalidate();
    }

    function _doCursorChanged(sender, pos, line, char)
    {
        var (cl, ct, cr, cb) = this._editor.cursorRect;

        if (this.horzAlign == #left) {
            cl += this.native.scrollX;
            cr += this.native.scrollX;
        } else if (this.horzAlign == #right) {
            cl += this.native.scrollX;
            cr += this.native.scrollX;
        }
        this._view.scrollTo(cl, ct, cr, cb);
        if (this.horzAlign == #right)
            this._view.performLayout();
    }

}
