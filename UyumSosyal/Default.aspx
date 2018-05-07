<%@ Page Language="C#" UICulture="tr-TR" %>

<%@ Import Namespace="Ext.Net.Utilities" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="UyumSosyal" %>
<%@ Import Namespace="UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared" %>

<script runat="server">
    protected string mobileVersion = "4.1";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["user"] == null)
        {
            Response.Redirect("Login.aspx");
            return;
        }

        if (!X.IsAjaxRequest)
        {
            this.ResourceManager1.DirectEventUrl = "/";

            Theme theme = Ext.Net.Theme.Triton;

            if (this.Session["Ext.Net.Theme"] != null)
            {
                theme = (Theme)this.Session["Ext.Net.Theme"];
            }

            ((Ext.Net.CheckMenuItem)this.FindControl(theme.ToString() + "ThemeItem")).Checked = true;

            this.TriggerField1.Focus();
            this.CheckMenuItemScriptMode.Checked = Convert.ToBoolean(this.Session["Ext.Net.SourceFormatting"]);

            ResourceManager.RegisterControlResources<TagLabel>();

            if (this.Request.QueryString["clearExamplesCache"] != null)
            {
                this.Page.Cache.Remove("ExamplesTreeNodes");
                X.Msg.Alert("Cache clear", "Tree nodes cache cleared.").Show();
            }

            // Makes dynamic data to server controls be bound to the page (like version on title).
            DataBind();
        }
    }

    protected void GetExamplesNodes(object sender, NodeLoadEventArgs e)
    {
        if (e.NodeID == "Root")
        {
            Ext.Net.NodeCollection nodes = this.Page.Cache["ExamplesTreeNodes"] as Ext.Net.NodeCollection;

            if (nodes == null)
            {
                nodes = UIHelpers.BuildTreeNodes(false);
                this.Page.Cache.Add("ExamplesTreeNodes", nodes, null, DateTime.Now.AddHours(1), System.Web.Caching.Cache.NoSlidingExpiration, CacheItemPriority.Default, null);
            }

            e.Nodes = nodes;
        }
    }

    [DirectMethod]
    public static int GetHashCode(string s)
    {
        return Math.Abs("/Moduls".ConcatWith(s).ToLower().GetHashCode());
    }

    [DirectMethod]
    public void SetTheme(string theme)
    {
        if (theme == "Blue")
        {
            theme = "Default";
        }

        theme = theme.Replace(" ", "");
        this.Session["Ext.Net.Theme"] = (Theme)Enum.Parse(typeof(Theme), theme);
    }

    [DirectMethod]
    public void ChangeScriptMode(bool debug)
    {
        if (debug)
        {
            this.Session["Ext.Net.ScriptMode"] = Ext.Net.ScriptMode.Debug;
            this.Session["Ext.Net.SourceFormatting"] = true;
        }
        else
        {
            this.Session["Ext.Net.ScriptMode"] = Ext.Net.ScriptMode.Release;
            this.Session["Ext.Net.SourceFormatting"] = false;
        }

        this.Response.Redirect("");
    }
</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>UyumSosyal v1.0</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="<%= "resources/css/main.css?" + ExtNetVersion.Full %>" />
    <link rel="shortcut icon" href="favicon.ico" />

    <script src="resources/js/perfect-scrollbar.min.js?0.6.8"></script>
    <script src="<%= "resources/js/main.js?" + ExtNetVersion.Full %>"></script>

    <script>
        // A workaround for the GitHub issue #915
        Ext.data.TreeModel.override({
            expand: function () {
                if (this.data.visible) {
                    this.callParent(arguments);
                }
            }
        });
    </script>
</head>
<body>
<ext:ResourceManager ID="ResourceManager1" runat="server" Theme="Triton" />

<ext:History runat="server">
    <Listeners>
        <Change Fn="change" />
    </Listeners>
</ext:History>

<ext:Viewport runat="server" Layout="BorderLayout">
<Items>
<ext:Container
    ID="RedirectOverlay"
    runat="server"
    Cls="redirect-overlay"
    WidthSpec="80%"
    Modal="true"
    Floating="true">
    <LayoutConfig>
        <ext:VBoxLayoutConfig Align="Stretch" />
    </LayoutConfig>
    <Items>
        <ext:Component
            Cls="redirect-overlay-body"
            runat="server"
            Html="<p>Mobile bir cihazdan geliyorsunuz. Mobil siteye yönlendirilmek ister misiniz? (Bu gereklidir.)</p>"/>

        <ext:Button
            runat="server"
            Text="Evet"
            Flex="1"
            Handler="onRedirect" />

        <ext:Button
            runat="server"
            Text="Burada Kalayım :)"
            Flex="1"
            Handler="onStay" />

        <ext:Checkbox
            ID="RememberCheckbox"
            Cls="remember-me"
            runat="server"
            BoxLabel="Bu Seçimi Hatırla" />
    </Items>
</ext:Container>

<ext:Panel
    runat="server"
    Header="false"
    Region="North"
    Border="false"
    Height="70">
    <Content>
        <header class="site-header" role="banner">
            <nav class="top-navigation">
                <div class="logo-container">
                    <img src="https://www.uyumsoft.com/wp/wp-content/uploads/2017/12/logo-v2@2x.png" alt="Uyumsoft" style="width: 100px;height: 50px;margin-top: -10px;">
                </div>
                
            </nav>
        </header>
    </Content>
</ext:Panel>
<ext:Panel
    runat="server"
    Region="West"
    Layout="Fit"
    Width="270"
    Header="false"
    MarginSpec="0"
    Border="false">
    <Items>
        <ext:TreePanel
            ID="exampleTree"
            runat="server"
            Header="false"
            AutoScroll="true"
            Lines="false"
            UseArrows="true"
            CollapseFirst="false"
            RootVisible="false"
            Animate="false"
            HideHeaders="true">
            <TopBar>
                <ext:Toolbar runat="server" Cls="left-header">
                    <Items>
                        <ext:TextField
                            ID="TriggerField1"
                            runat="server"
                            EnableKeyEvents="true"
                            Flex="1"
                            EmptyText="Ara..."
                            RemoveClearTrigger="true">
                            <Triggers>
                                <ext:FieldTrigger Icon="Clear" Hidden="true" />
                            </Triggers>
                            <Listeners>
                                <KeyUp Fn="keyUp" Buffer="500" />
                                <TriggerClick Fn="clearFilter" />
                                <SpecialKey Fn="filterSpecialKey" Delay="1" />
                            </Listeners>
                        </ext:TextField>

                        <ext:Button runat="server" id="OptionsButton" IconCls="fa fa-cog" ToolTip="Options" ArrowVisible="false">
                            <Menu>
                                <ext:Menu runat="server" MinWidth="200">
                                    <Items>
                                        <ext:MenuItem runat="server" Text="Hepsini Genişlet" IconCls="icon-expand-all">
                                            <Listeners>
                                                <Click Handler="#{exampleTree}.expandAll(false);" />
                                            </Listeners>
                                        </ext:MenuItem>

                                        <ext:MenuItem runat="server" Text="Hepsini Sıkıştır" IconCls="icon-collapse-all">
                                            <Listeners>
                                                <Click Handler="#{exampleTree}.collapseAll(false);" />
                                            </Listeners>
                                        </ext:MenuItem>

                                        <ext:MenuSeparator runat="server" />

                                        <ext:CheckMenuItem runat="server" Text="Yeni Olanlar">
                                            <Listeners>
                                                <CheckChange Fn="filterNewExamples" />
                                            </Listeners>
                                        </ext:CheckMenuItem>

                                        <ext:CheckMenuItem
                                            ID="CheckMenuItemScriptMode"
                                            runat="server"
                                            Text="Test Modu">
                                            <Listeners>
                                                <CheckChange Handler="App.direct.ChangeScriptMode(checked);" />
                                            </Listeners>
                                        </ext:CheckMenuItem>

                                        <ext:MenuSeparator runat="server" />

                                        <ext:MenuItem runat="server" Text="Theme" Icon="Paintcan">
                                            <Menu>
                                                <ext:Menu runat="server" MinWidth="200">
                                                    <Items>
                                                        <ext:CheckMenuItem ID="AriaThemeItem" runat="server" Text="Aria" Group="theme" />
                                                        <ext:CheckMenuItem ID="DefaultThemeItem" runat="server" Text="Blue" Group="theme" />
                                                        <ext:CheckMenuItem ID="GrayThemeItem" runat="server" Text="Gray" Group="theme" />
                                                        <ext:CheckMenuItem ID="CrispThemeItem" runat="server" Text="Crisp" Group="theme" />
                                                        <ext:CheckMenuItem ID="CrispTouchThemeItem" runat="server" Text="Crisp Touch" Group="theme" />
                                                        <ext:CheckMenuItem ID="NeptuneThemeItem" runat="server" Text="Neptune" Group="theme" />
                                                        <ext:CheckMenuItem ID="NeptuneTouchThemeItem" runat="server" Text="Neptune Touch" Group="theme" />
                                                        <ext:CheckMenuItem ID="TritonThemeItem" runat="server" Text="Triton" Group="theme" />
                                                    </Items>
                                                    <Listeners>
                                                        <Click Fn="themeChange" />
                                                    </Listeners>
                                                </ext:Menu>
                                            </Menu>
                                        </ext:MenuItem>

                                        <ext:MenuSeparator runat="server" />

                                        <ext:MenuItem runat="server" Text="Arama Şekli" Icon="Find">
                                            <Menu>
                                                <ext:Menu runat="server" MinWidth="200">
                                                    <Items>
                                                        <ext:CheckMenuItem
                                                            ID="SearchByTitles"
                                                            runat="server"
                                                            Checked="true"
                                                            Text="Başlık" />

                                                        <ext:CheckMenuItem
                                                            ID="SearchByTags"
                                                            runat="server"
                                                            Checked="true"
                                                            Text="Etiket" />
                                                    </Items>
                                                </ext:Menu>
                                            </Menu>
                                        </ext:MenuItem>

                                        <ext:MenuItem runat="server" Text="Şifre Değiştir" Icon="ServerConnect">
                                                        <Listeners>
                                                            <Click Fn="function() {top.document.location.href = 'UpdatePassword.aspx';}" />
                                                        </Listeners>
                                                    </ext:MenuItem>
                                    </Items>
                                </ext:Menu>
                            </Menu>
                        </ext:Button>
                    </Items>
                </ext:Toolbar>
            </TopBar>

            <Store>
                <ext:TreeStore runat="server" OnReadData="GetExamplesNodes">
                    <Proxy>
                        <ext:PageProxy>
                            <RequestConfig Method="GET" Type="Load" />
                        </ext:PageProxy>
                    </Proxy>
                    <Root>
                        <ext:Node NodeID="Root" Expanded="true" />
                    </Root>
                    <Fields>
                        <ext:ModelField Name="tags" />
                        <ext:ModelField Name="flags" />
                    </Fields>
                </ext:TreeStore>
            </Store>
            <ColumnModel>
                <Columns>
                    <ext:TreeColumn runat="server" DataIndex="text" Flex="1">
                        <Renderer Fn="treeRenderer" />
                    </ext:TreeColumn>
                </Columns>
            </ColumnModel>
            <Listeners>
                <ItemClick Handler="onTreeItemClick(record, e);" />
                <AfterRender Fn="onTreeAfterRender" />
            </Listeners>
        </ext:TreePanel>
    </Items>
</ext:Panel>
<ext:TabPanel
    ID="ExampleTabs"
    runat="server"
    Region="Center"
    MarginSpec="0"
    Cls="tabs"
    MinTabWidth="115">
    <Items>
        <ext:Panel
            ID="tabHome"
            runat="server"
            Title="Ana Sayfa"
            HideMode="Offsets"
            IconCls="fa fa-home">
            <Loader runat="server" Mode="Frame" Url="Home/">
                <LoadMask ShowMask="true" />
            </Loader>
        </ext:Panel>
    </Items>
    <Listeners>
        <TabChange Fn="addToken" />
    </Listeners>
    <Plugins>
        <ext:TabCloseMenu runat="server" />
    </Plugins>
</ext:TabPanel>
</Items>
</ext:Viewport>
</body>
</html>
