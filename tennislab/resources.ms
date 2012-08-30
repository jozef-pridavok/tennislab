class Res
{
    var img = {
    };

    var txt = {
        errors: [
            "",
            "Maintainance of the system!",
            "Account has been already registered!",
            "Invalid email or password!",
            "Account is temporary disabled!",
            "Job not found!",
            "Job has been expired!",
            "Insufficiency of credits!",
            "Session expired, you have to login again!"
        ],
        applied: "You've applied successful",
        
    }

    function loadBitmap(name, ext = "png")
    {
        var file = String.printf("app://images/%s_%d.%s", name, System.width, ext);
        if (!System.isFile(file))
            file = String.printf("app://images/%s.%s", name, ext);
        var bitmap = Bitmap.fromFile(file);
        return bitmap;
    }

    function load()
    {
        Res.img.bg = Res.loadBitmap("bg");
        Res.img.bgTop = Res.loadBitmap("bg_top");
        Res.img.bgBottom = Res.loadBitmap("bg_bottom");
        Res.img.employerLogo = Res.loadBitmap("employer-logo");
        Res.img.btnAn = Res.loadBitmap("buttonA_n");
        Res.img.btnAd = Res.loadBitmap("buttonA_d");
        Res.img.titleItemN = Res.loadBitmap("titleItem_n");
        Res.img.titleItemD = Res.loadBitmap("titleItem_d");
        Res.img.titleItemBN = Res.loadBitmap("titleItemB_n");
        Res.img.titleItemBD = Res.loadBitmap("titleItemB_d");
        Res.img.info = Res.loadBitmap("info");
        Res.img.arrow = Res.loadBitmap("arrow");
        Res.img.dollar = Res.loadBitmap("dollar");
        Res.img.at = Res.loadBitmap("at");
        Res.img.phone = Res.loadBitmap("phone");
    }
}