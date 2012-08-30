include "lib://uix/base/graphic/drawing.ms";

class DrawingCache
{
    function this()
    {
        this._storage = {};
    }

    property instance(v)
    {
        get {

            if( DrawingCache.instace === undefined)
                DrawingCache.instace = new DrawingCache();

            return DrawingCache.instace
        }
    }

    property storage(v)
    {
        get return this._storage;
    }

    function hasDrawing(key)
    {
        return this.storage[key] instanceof Drawing ? true : false;
    }


    function getDrawing(key)
    {
        if(this.hasDrawing(key) === true)
            return this.storage[key];

        throw new Exception("[DrawingCache.getDrawing] undefined key:" + key);
    }

    function storeDrawing(key,obj)
    {
        this.storage[key] = obj;
    }

}