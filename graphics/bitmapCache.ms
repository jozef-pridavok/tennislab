class BitmapCache
{
    // Constructs cached bitmaps
    function this()
    {
        this._bitmaps = [];
    }
    function getBitmap(fileName = "")
    {
        var existing = this._bitmaps.filter(:x :x.fileName == fileName);
        if (existing.length == 1)
            return existing[0].image;
        assert System.isFile(fileName);
        var image = Bitmap.fromFile(fileName);
        assert image != null;
        this._bitmaps.push({fileName: fileName, image: image});
        return image;
    }
}