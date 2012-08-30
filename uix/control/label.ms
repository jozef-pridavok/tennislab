include "lib://uix/control.ms"

/**
@class Label
*/
class Label : Control
{
    // @region Initialization

    function init()
    {
        super.init(Moscrif.TextView);
        //super.init();

        this._view.paint = Label.style.foreground.native;
        this._view.stretch = #none;
        this._view.width = this.options.width || Label.style.width;
        this._view.height = this.options.height || Label.style.height;
        this._view.autoSize = this.options.autoSize || #fixed;
        this._view.multiLine = this.options.multiLine || false;
        this._view.horzAlign = this.options.horzAlign || #center;
        this._view.vertAlign = this.options.vertAlign || #center;
    }

    /**
     * Property fot text label.
     * @param String text
     * @return String text
       @throw InvalidArgument instance of string expected
     */
    property text(v)
    {
        get return this._view.text;
        set this._view.text = v.toString();
    }

    /**
    Multiline property, default is set to false.
    @param Boolean v
    @return Boolean
    */
    property multiLine(v)
    {
        get return this._view.multiLine;
        set this._view.multiLine = v;
    }

    /**
     * Property for horizontal align
     * @param Symbol v
        #left, #center, #right  align
     * @return Symbol
     */
    property horzAlign(v)
    {
        get return this._view.horzAlign;
        set this._view.horzAlign = v;
    }

    /**
     * Property for vertical align
     * @param Symbol v
       #top, #center, #bottom  align
     * @return Symbol
     */
    property vertAlign(v)
    {
        get return this._view.vertAlign;
        set this._view.vertAlign = v;
    }

    function drawDefault(canvas)
    {
        Application.skin.drawLabel(canvas, this);
    }

}