class ColorPaint
{
    /**
    @static
    */
    function create(color)
    {
        var paint = new Paint();
        paint.style = #stroke;
        paint.color = color;
        return paint;
    }

    /**
    @static
    @private
    */
    var stockPaints = null;

    /**
    @static
    */
    function stock()
    {
        if (ColorPaint.stockPaints == null) {
            ColorPaint.stockPaints = {
                transparent: ColorPaint.create(0x00000000),
                black: ColorPaint.create(0xff000000),
                white: ColorPaint.create(0xffffffff),
                red: ColorPaint.create(0xffff0000),
                green: ColorPaint.create(0xff00ff00),
                blue: ColorPaint.create(0xff0000ff),
                silver: ColorPaint.create(0xffdadada),
            }
        }
        return ColorPaint.stockPaints;
    }
}