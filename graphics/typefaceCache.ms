class TypefaceCache
{
    function this()
    {
        //this._typefaces = [];
    }
    function getTypeface(name = "", style = #normal)
    {
        // object-notation can be used as first argument
        if (typeof name == #object) {
            var descr = name;
            name = descr.name.toLowerCase();
            style = descr.style || #normal;
        }

        return Typeface.fromName(name, style);
        // TODO: typeface nema name, ma len uniqueId a to vieme az je typeface vytvoreny, takze cache sa neda spravit
        /*
        if (name == "") face = "freesans";
        var found = null;
        for (var f in this._typefaces)
            if (f.name.toLowerCase() === name && f.style == style)
                return f;
        found = Typeface.fromName(name, style);
        this._typefaces.push(found);
        return found;
        */
    }
}