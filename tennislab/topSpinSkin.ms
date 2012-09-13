include "lib://uix/skin.ms"
include "lib://graphics/gradient.ms"
include "app://jobForm.ms"

class TopSpinSkin : Skin
{

    var gap = System.width / 60;

    function drawApplication(canvas, app)
    {
        canvas.clear(0xffffffff);
        canvas.drawBitmap(Res.img.bg, System.width - Res.img.bg.width, System.height - Res.img.bg.height);
    }

    function drawForm(canvas, form)
    {
    }

    function drawButton(canvas, button)
    {
        assert button instanceof Button;
        var style = button.pressed ? Button.style.pressed : Button.style;
        var fg = style.foreground.native;
        var (tw, th) = fg.measureText(button.text);
        th -= fg.fontDescent;
        //th = fg.fontBottom - fg.fontTop;
        //logI(">>>", th,  fg.fontTop, fg.fontBottom, fg.fontDescent, fg.fontAscent, fg.fontAscent - fg.fontDescent, fg.fontDescent - fg.fontAscent);
        //th = fg.fontAscent - fg.fontDescent;
        var delta = button.pressed ? Skin.pressedDelta : 0;
        canvas.drawBitmapNine(button.pressed ? Res.img.btnAd : Res.img.btnAn, 0, 0, button.width, button.height);
        canvas.drawText(button.text, (button.width - tw) / 2, (button.height + th) / 2 + delta, fg);
    }

    function drawTitleBar(canvas, titleBar)
    {
        assert titleBar instanceof TitleBar;
        var fg = TitleBar.style.foreground.native;
        var gradient = TitleBar.style.gradient.native;
        var border = TitleBar.style.border.native;
        canvas.drawRect(0, 0, titleBar.width, titleBar.height, gradient);
        canvas.drawRect(0, titleBar.height-6, titleBar.width, titleBar.height, border);
        if (titleBar.text.length > 0) {
            var (tw, th) = fg.measureText(titleBar.text);
            var (left, right) = titleBar.labelLimits();
            var offset, align = titleBar.labelAlign || #center;
            if (align == #left) offset = left;
            else if (align == #right) offset = right - tw;
            else if (align == #center) offset = left + (right - left)/2 - tw/2;
            else if (align == #screen) offset = System.width/2 - tw/2;
            canvas.drawText(titleBar.text, offset, (titleBar.height + th) / 2, fg);
        }
    }

    function drawTitleItem(canvas, titleItem)
    {
        assert titleItem instanceof TitleItem;
        var fg = TitleItem.style.foreground.native;
        var radius = System.width / 100;
        var delta = titleItem.pressed ? Skin.pressedDelta : 0;
        if (titleItem.kind == #back) {
            var h = Res.img.titleItemBD.width / 2;
            var v = Res.img.titleItemBD.height / 10;
            canvas.drawBitmapNine(titleItem.pressed ? Res.img.titleItemBD : Res.img.titleItemBN, 0, 0, titleItem.width, titleItem.height, null, 50, 0, 0, 0);
        } else {
            canvas.drawBitmapNine(titleItem.pressed ? Res.img.titleItemD : Res.img.titleItemN, 0, 0, titleItem.width, titleItem.height);
        }
        if (titleItem.image instanceof Bitmap)
            canvas.drawBitmap(titleItem.image, (titleItem.width - titleItem.image.width) / 2, (titleItem.height - titleItem.image.height) / 2);
        else {
            var text = titleItem.text;
            var (tw, th) = fg.measureText(text);
            th -= fg.fontDescent;
            canvas.drawText(text, (titleItem.width - tw) / 2 + delta, (titleItem.height + th) / 2 + delta, fg);
        }
    }

    function drawListView(canvas, list)
    {
    }

    function drawListItem(canvas, listItem)
    {
        assert listItem instanceof ListItem;
        var style = listItem.pressed ? ListItem.style.pressed : ListItem.style;
        var fg = style.foreground.native;
        var isRefresh = listItem.kind == #refresh;
        if (isRefresh)
            fg = ListItem.style.foreground3.native;
        var (tw, th) = fg.measureText(listItem.text);
        th = fg.fontBottom - fg.fontTop;
        var delta = listItem.pressed ? Skin.pressedDelta : 0;
        var text = listItem.text;
        if (text.length > 30) text = text.substr(0, 30) + "...";
        canvas.drawText(text, gap + delta + (isRefresh ? listItem.width/2-gap : 0), th + gap + delta, fg);
        fg = style.foreground2.native;
        if (isRefresh)
            fg = ListItem.style.foreground3.native;
        th = fg.fontBottom - fg.fontTop;
        text = listItem.description;
        if (text.length > 50) text = text.substr(0, 50) + "...";
        canvas.drawText(text, gap + delta + (isRefresh ? listItem.width/2-gap : 0), 3*th + gap + delta, fg);
        canvas.drawLine(0, listItem.height - 1, listItem.width, listItem.height - 1, fg);
        if (!isRefresh)
            canvas.drawBitmap(Res.img.arrow, listItem.width - Res.img.arrow.width - System.width/30 + delta, (listItem.height - Res.img.arrow.height)/2 + delta);
    }

    function drawTileView(canvas, tiles)
    {
    }

    function drawTileItem(canvas, tileItem)
    {
        assert tileItem instanceof TileItem;
        var style = tileItem.pressed ? TileItem.style.pressed : TileItem.style;
        var bg = style.background.native;
        var fg = style.foreground.native;
        var isRefresh = tileItem.kind == #refresh;
        var (tw, th) = fg.measureText(tileItem.text);
        var delta = tileItem.pressed ? Skin.pressedDelta : 0;
        canvas.drawRect(0, 0, tileItem.width, tileItem.height, bg);
        if (isRefresh) {
            fg = ListItem.style.foreground3.native;
            canvas.drawTextBox(tileItem.text, 10 + delta, 10 + delta, tileItem.width, tileItem.height, fg, #center);
            return;
        }
        canvas.drawTextBox(tileItem.text, 10 + delta, 10 + delta, tileItem.width, tileItem.height, fg);

        fg = style.foreground2.native;
        var text = tileItem.description || "";
        (tw, th) = fg.measureText(text);
        th = fg.fontBottom - fg.fontTop;
        if (text.length > 50) text = text.substr(0, 50) + "...";
        canvas.drawText(text, tileItem.width - gap + delta - tw, tileItem.height - th + gap + delta, fg);

    }

}

Label.style.foreground = new Foreground({color: 0xff000000, fontSize: System.height/30});

Button.style.foreground = new Foreground({color: 0xffffffff, fontSize: System.height/30});
Button.style.pressed.foreground = Button.style.foreground;
TitleBar.style.foreground = new Foreground({color: 0xff00ffff, fontSize: System.height/20});
TitleBar.style.gradient = new Gradient({kind: #linear, points:{start:{x:0,y:0}, end:{x:0,y:System.height/20}}, colors:[0xff424242, 0xff262626], positions:[0.0, 1.0]});
TitleBar.style.border = new Foreground({color: 0xff505032});
TitleItem.style.foreground = new Foreground({color: 0xff000000, fontSize: System.height/30});
TitleItem.style.padding = System.width / 30;
ListItem.style.background = new Background({color: 0x00ffffff});
ListItem.style.foreground = new Foreground({color: 0xff000000, fontSize: System.height/30});
ListItem.style.foreground2 = new Foreground({color: 0xff000000, fontSize: System.height/50});
ListItem.style.foreground3 = new Foreground({color: 0xffdadada, fontSize: System.height/50, textAlign:#center});
ListItem.style.pressed.foreground = ListItem.style.foreground;
ListItem.style.pressed.foreground2 = ListItem.style.foreground2;

TileItem.style.height = System.height / 6;
TileItem.style.foreground = new Foreground({color: 0xff000000, fontSize: System.height/30});
TileItem.style.foreground2 = new Foreground({color: 0xffdadada, fontSize: System.height/50});
TileItem.style.foreground3 = new Foreground({color: 0xffdadada, fontSize: System.height/50, textAlign:#center});
TileItem.style.pressed.background = TileItem.style.background;
TileItem.style.pressed.foreground = TileItem.style.foreground;
TileItem.style.pressed.foreground2 = TileItem.style.foreground2;

JobForm.style = {
    title: new Foreground({color: 0xff000000, fontSize: System.height/30}),
    description: new Foreground({color: 0xff000000, fontSize: System.height/40, textAlign:#left})
}

/*

button : {
    foreground: new Foreground({color: 0xffffffff, fontSize: System.height/30})
    foreground: foreground({color: 0xffffffff, fontSize: System.height/30})
    color:
    font-size:
    background: image("");
    background: gradient([1, 2]);
    background-color:
    background-gradient:
    background-image: "app://aaa.png",
}

*/
