class Settings
{
    // @region All these class variables will be serialized
    var login = "";
    var session = "";
    var credits = 0;
    var accountType = 101; // employee

    // ... etc, you can add/remove fields according your needs
    // @endregion
    // @region Static functions
    // Static function that saves options to file (json)
    function save()
    {
        // rewrite file
        var file = Stream.openFile("data://settings.dat", "w+");
        if (!file) {
            logE("Unable to create settings file!");
            return;
        }
        // create pure object without functions (pure object)
        var options =  {};
        for (var opt in Settings)
            if (typeof Settings[opt] != #function)   // skip functions
                options[opt] = Settings[opt]         // create new attribute with value
        file.printf("%V", options);                 // formatted print to file
        file.close();                               // close and release
    }

    // Static function that loads options from file (json)
    function load()
    {
        // open file for reading
        var file = Stream.openFile("data://settings.dat", "r");
        if (!file) {
            logW("Unable to load settings file!");
            return;
        }
        var options = parseData(file);              // load data to json
        file.close();                               // close file
        for (var opt in options)                    // iterate all attributes
            Settings[opt] = options[opt];            // apply to class
    }
    // @endregion
}