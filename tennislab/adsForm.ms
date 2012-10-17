include "lib://uix/form.ms"
include "lib://uix/list/listView.ms"
include "lib://uix/title/titleBar.ms"
include "lib://uix/transition/slideToRight.ms"
include "lib://uix/transition/slideToTop.ms"
include "app://aboutForm.ms"
include "app://accountForm.ms"
include "app://contactsForm.ms"

class AdsForm : Form
{
    var singleton = null;

    function create(options = {})
    {
        if (AdsForm.singleton == null)
            AdsForm.singleton = new AdsForm(options);
        return AdsForm.singleton;
    }

    function beforeInit()
    {
        super.beforeInit();
        assert AdsForm.singleton == null;
        this._initialisation = true;
    }

    function init()
    {
        super.init();
        this._list = new ListView({name:"listView", stretch: #both});
        this.add(new TitleBar({name:"titleBar", text:"My Jobs",
            titleOffset: System.width/12,
            leftItems: [new TitleItem({name:"info", image:Res.img.info, onClick:::this super._showAbout()})],
            rightItems: [new TitleItem({name:"account", text:"Account", onClick:::this super._showAccount()})]
        }));
        this.add(this._list);
    }

    function afterInit()
    {
        super.afterInit();
        assert AdsForm.singleton == null;
        AdsForm.singleton = this;
        this._initialisation = false;
    }

    function activate()
    {
        super.activate();
        this._update();
    }

    function deactivate()
    {
        super.deactivate();
    }

    function keyReleased(key)
    {
        if (key == #back)
            Application.instance.quit();
    }

    function _update()
    {
        var self = this;
        this._list.suspendLayout();
        this._list.removeAll();
        this._list.beginWait();
        AdsWebService.getListAds(10,
            function(ads) {
                self._list.endWait();
                self._list.suspendLayout();
                for (var ad in ads) {
                    var item = new ListItem({name:ad["id"].toString(), text:ad["title"], description:String.printf("Contacts %s", ad["applications"]), ad:ad });
                    item.onClick = function() { self._adClicked(this); };
                    self._list.add(item);
                }
                self._list.resumeLayout(true);
            },
            function(error)  {
                self._list.endWait();
                if (Settings.accountType == 101) {
                    //Application.instance.pop(new SlideToTop());
                    Application.instance.push(JobsForm.create({name:"JobsForm"}), new SlideToTop());
                    return;
                }
            }
        );
        this._list.resumeLayout(true);
    }

    function _adClicked(item)
    {
        if (Settings.session === "") {
            this._showAccount();
            return;
        }
        var detail = ContactsForm.create({name: "ContactsForm", ad:item.ad, title:item.ad["title"]});
        Application.instance.push(detail, new SlideToLeft());
    }

    function _showAbout()
    {
        Application.instance.push(AboutForm.create(), new SlideToRight());
    }

    function _showAccount()
    {
        Application.instance.push(AccountForm.create(), new SlideToLeft());
    }
}
