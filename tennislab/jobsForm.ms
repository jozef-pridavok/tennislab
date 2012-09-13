include "lib://uix/form.ms"
include "lib://uix/list/listView.ms"
include "lib://uix/tile/tileView.ms"
include "lib://uix/title/titleBar.ms"
include "lib://uix/transition/slideToRight.ms"
include "lib://uix/transition/slideToTop.ms"
include "app://aboutForm.ms"
include "app://jobForm.ms"
include "app://accountForm.ms"

class JobsForm : Form
{
    var singleton = null;
    var isTablet = System.IS_TABLET;

    function create(options = {})
    {
        if (JobsForm.singleton == null)
            JobsForm.singleton = new JobsForm(options);
        return JobsForm.singleton;
    }

    function beforeInit()
    {
        super.beforeInit();
        assert JobsForm.singleton == null;
        this._initialisation = true;
    }

    function init()
    {
        super.init();
        var clazz = isTablet ? TileView : ListView;
        this._list = new clazz({name:"listView", stretch: #both});
        this.add(new TitleBar({name:"titleBar", text:"Jobs",
            //titleOffset: System.width/12,
            //labelAlign: #center,
            leftItems: [new TitleItem({image:Res.img.info, onClick:::this super._showAbout()})],
            rightItems: [new TitleItem({text:"Account", onClick:::this super._showAccount()})
                //, new TitleItem({text:"Account", onClick:::this super._showAccount()})
                ]
        }));
        this.add(this._list);
    }

    function afterInit()
    {
        super.afterInit();
        assert JobsForm.singleton == null;
        JobsForm.singleton = this;
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
        super.keyReleased(key);
        logI(key);
        if (key == #back)
            Application.instance.quit();
    }

    function orientationChanged(orientation)
    {
        if (isTablet) {
            this._list._layout.columns = orientation == #portrait ? 2 : 3;
        }
        super.orientationChanged(orientation);
    }

    function _update()
    {
        var self = this;
        self._list.suspendLayout();
        self._list.removeAll();
        self._list.beginWait();
        var reload;
        var clazz = isTablet ? TileItem : ListItem;
        function fillJobs(jobs) {
            self._jobs = jobs;
            self._list.endWait();
            self._list.suspendLayout();
            for (var job in jobs) {
                var item = new clazz({name:job["id"].toString(), text:job["title"], description:job["deadlineDate"], job:job });
                item.onClick = function() { self._jobClicked(this); };
                self._list.add(item);
            }
            var item = new clazz({name:"refresh", text:"Refresh", description:"tap here to reaload data", kind:#refresh });
            item.onClick = function() { self._jobs = null; self._list.removeAll(); reload(); };
            self._list.add(item);

            self._list.resumeLayout(true);
        }
        function reloadJobs() {
            JobsWebService.getList(10,
                fillJobs,
                function(error)  {
                    self._list.endWait();
                }
            );
        }
        reload = function() {
            self._list.suspendLayout();
            self._list.removeAll();
            self._list.beginWait();
            reloadJobs();
        }
        if (self._jobs)
            fillJobs(self._jobs);
        else
            reloadJobs();
        self._list.resumeLayout(true);
    }

    function _jobClicked(item)
    {
        if (Settings.session === "") {
            this._showAccount();
            return;
        }
        var detail = JobForm.create({name: "JobForm", job:item.job, title:item.job.firstName});
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
