<%@ Page Language="C#" %>

<script runat="server">
    protected void ReloadData(object sender, DirectEventArgs e)
    {
        this.Chart1.GetStore().DataBind();
    }
</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <link href="/resources/css/examples.css" rel="stylesheet" />

    <script>
        var tipRenderer = function (toolTip, record, context) {
            var total = 0;

            App.Chart1.getStore().each(function (rec) {
                total += rec.get('Data1');
            });

            toolTip.setTitle(record.get('Name') + ': ' + Math.round(record.get('Data1') / total * 100) + '%');
        };

        var saveChart = function (btn) {
            Ext.MessageBox.confirm('İndirme İzni', 'Ekran resmini indirmek ister misiniz?', function (choice) {
                if (choice === 'yes') {
                    btn.up('panel').down('polar').download();
                }
            });
        };
    </script>
</head>
<body>
<form runat="server">
    <ext:ResourceManager runat="server" />

    <h1>Hoş Geldiniz</h1>

    <p>Mail Gönderim Durumları</p>

    <ext:Panel
        runat="server"
        Width="800"
        Height="600"
        Title="MailChimp Test Datası"
        Layout="FitLayout">
        <TopBar>
            <ext:Toolbar runat="server">
                <Items>
                    <ext:ToolbarFill runat="server" />

                    <ext:Button
                        runat="server"
                        Text="Kaydet"
                        Icon="Disk"
                        Handler="saveChart" />

                    <ext:Button
                        runat="server"
                        Text="Yenile"
                        Icon="ArrowRefresh"
                        OnDirectClick="ReloadData" />

                    <ext:Button runat="server" Text="Donut" EnableToggle="true">
                        <Listeners>
                            <Toggle Handler="App.Chart1.series[0].setDonut(pressed ? 35 : false); App.Chart1.redraw();" />
                        </Listeners>
                    </ext:Button>

                    <ext:Button
                        runat="server"
                        Text="Gözlem"
                        Handler="this.up('panel').down('polar').preview();" />
                </Items>
            </ext:Toolbar>
        </TopBar>

        <Items>
            <ext:PolarChart
                ID="Chart1"
                runat="server"
                Shadow="true"
                InsetPadding="60"
                InnerPadding="20">
                <LegendConfig runat="server" Dock="Right" />
                <Store>
                    <ext:Store
                        runat="server"
                        Data="<%# UyumSosyal.Moduls.ChartData.GenerateData(6) %>"
                        AutoDataBind="true">
                        <Model>
                            <ext:Model runat="server">
                                <Fields>
                                    <ext:ModelField Name="Name" />
                                    <ext:ModelField Name="Data1" />
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <Interactions>
                    <ext:ItemHighlightInteraction />
                    <ext:RotateInteraction />
                </Interactions>
                <Series>
                    <ext:PieSeries
                        AngleField="Data1"
                        ShowInLegend="true"
                        Donut="0"
                        HighlightMargin="20">
                        <Label Field="Name" Display="Rotate" FontSize="18" FontFamily="Arial" />
                        <Tooltip runat="server" TrackMouse="true" Width="140" Height="28">
                            <Renderer Fn="tipRenderer" />
                        </Tooltip>
                    </ext:PieSeries>
                </Series>
            </ext:PolarChart>
        </Items>
    </ext:Panel>
</form>
</body>
</html>