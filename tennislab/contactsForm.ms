include "lib://uix/form.ms"
include "lib://uix/list/listView.ms"
include "lib://uix/title/titleBar.ms"
include "lib://uix/transition/slideToRight.ms"
include "app://employeeForm.ms"

class ContactsForm : Form
{
    var singleton = null;

    function create(options = {})
    {
        if (ContactsForm.singleton == null)
            ContactsForm.singleton = new ContactsForm(options);
        return ContactsForm.singleton;
    }

    function beforeInit()
    {
        super.beforeInit();
        assert ContactsForm.singleton == null;
        this._initialisation = true;
    }

    function init()
    {
        super.init();
        this._list = new ListView({name:"listView", stretch: #both});
        this.add(new TitleBar({name:"titleBar", text:"Contacts",
            leftItems: [new TitleItem({text:"back", kind:#back, onClick:::Application.instance.pop(new SlideToRight())})]
        }));
        this.add(this._list);
    }

    function afterInit()
    {
        super.afterInit();
        assert ContactsForm.singleton == null;
        ContactsForm.singleton = this;
        this._initialisation = false;
    }

    function keyReleased(key)
    {
        logI("form", this.name,  key);
        if (key == #back)
            Application.instance.pop(new SlideToRight());
    }

    property ad(v)
    {
        get return this._ad;
        set this._ad = v;
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

    function _update()
    {
        var self = this;
        self._list.suspendLayout();
        self._list.removeAll();
        self._list.beginWait();
        AdsWebService.getListApplications(self._ad["id"], 10,
            function(contacts) {
                self._list.endWait();
                self._list.suspendLayout();
                for (var contact in contacts) {
                    var item = new ListItem({name:contact["id"].toString(), text:contact["name"], description:contact["describe"], contact:contact });
                    item.onClick = function() { self._employeeClicked(this); };
                    self._list.add(item);
                }
                self._list.resumeLayout(true);
            },
            function(error)  {
                self._list.endWait();
            }
        );
        self._list.resumeLayout(true);
    }

    function _employeeClicked(item)
    {
        var detail = EmployeeForm.create({name: "EmployeeForm", contact:item.contact, title:item.employee["name"]});
        Application.instance.push(detail, new SlideToLeft());
    }

    function _showAbout()
    {
        Application.instance.push(AboutForm.create(), new SlideToRight());
    }

    function _showAccount()
    {
        Application.instance.push(AccountForm.create(), new SlideToTop());
    }
}
