﻿<%@ Control Language="C#" %>
<%@ Import Namespace="UyumSosyal" %>


<script runat="server">
    protected void StoreFirsatSol_RefershData(object sender, StoreReadDataEventArgs e)
    {
        X.MessageBox.Show( new MessageBoxConfig() {
            Message = "Islem yapilirken lutfen bekleyiniz.",
            ProgressText = "Bekleyiniz...",
            Width = 300,
            Wait = true,
            WaitConfig = new WaitConfig() { Interval = 200}
        });
        try
        {
            var store = (Store)sender;
            store.DataSource = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.FirsatSariAlanListesi.GetFilterL(0, 1000);
            store.DataBind();
            //X.MessageBox.Hide();
        }
        catch(Exception ex)
        {

            Helper.Error("HedefKitleFirsatListe'de web service hatası : " + ex.Message);
        }
    }

    protected void StoreFirsatSag_RefershData(object sender, StoreReadDataEventArgs e)
    {
        X.MessageBox.Show( new MessageBoxConfig() {
            Message = "Islem yapilirken lutfen bekleyiniz.",
            ProgressText = "Bekleyiniz...",
            Width = 300,
            Wait = true,
            WaitConfig = new WaitConfig() { Interval = 200}
        });
        try
        {
            var store = (Store)sender;
            store.DataSource = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.FirsatSariAlanListesi.GetFilterR(0, 1000);
            store.DataBind();
            //X.MessageBox.Hide();
        }
        catch(Exception ex)
        {
            
            Helper.Error("HedefKitleFirsatListe'de web service hatası : " + ex.Message);
        }
    }


</script>

<script>
    var getDragDropText = function () {
        var buf = [];

        buf.push("<ul>");

        Ext.each(this.view.panel.getSelectionModel().getSelection(), function (record) {
            buf.push("<li>"+record.data.desc+"</li>");
        });

        buf.push("</ul>");

        return buf.join("");
    };
</script>

<ext:Panel runat="server" Width="700" Height="330">
    <LayoutConfig>
        <ext:HBoxLayoutConfig Align="Stretch" Padding="0" />
    </LayoutConfig>
    <Items>
        <ext:GridPanel
            ID="GridPanel1"
            runat="server"
            MultiSelect="false"
            Flex="1"
            Title="Liste"
            MarginSpec="0 2 0 0">
            <Store>
                <ext:Store ID="StoreFirsatL" OnReadData="StoreFirsatSol_RefershData" runat="server">
                    <Listeners>
                        <Load Handler="Ext.MessageBox.hide();" Delay="1000"/>
                    </Listeners>
                    <Model>
                        <ext:Model runat="server">
                            <Fields>
                                <ext:ModelField Name="code" />
                                <ext:ModelField Name="desc" />
                                <ext:ModelField Name="id" />
                                <ext:ModelField Name="master_no" />
                            </Fields>
                        </ext:Model>
                    </Model>
                </ext:Store>
            </Store>
            <ColumnModel>
                <Columns>
                    <ext:Column runat="server" Text="Fırsat" Width="160" DataIndex="desc" Flex="1" />
                </Columns>
            </ColumnModel>
            <View>
                <ext:GridView runat="server">
                    <Plugins>
                        <ext:GridDragDrop runat="server" DragGroup="firstGridDDGroup" DropGroup="secondGridDDGroup" />
                    </Plugins>
                    <Listeners>
                        <AfterRender Handler="this.plugins[0].dragZone.getDragText = getDragDropText;" Delay="1" />
                        <Drop Handler="
                            Ext.MessageBox.show({
	                          msg: 'Islem yapilirken lutfen bekleyiniz.',
	                          progressText: 'Bekleyiniz...',
	                          width:300,
	                          wait:true,
	                          waitConfig: {interval:200}
	                        });
                            console.log(data.records[0]);
                            ekleSilFirsat(
                                data.records[0].get('id'),
                                data.records[0].get('desc'),
                                false);
                            " />
                    </Listeners>
                </ext:GridView>
            </View>
        </ext:GridPanel>
        <ext:GridPanel
            ID="GridPanel2"
            runat="server"
            MultiSelect="false"
            Title="Eklenenler"
            Flex="1"
            MarginSpec="0 0 0 3">
            <Store>
                <ext:Store ID="StoreFirsatR" OnReadData="StoreFirsatSag_RefershData" runat="server">
                    <Listeners>
                        <Load Handler="Ext.MessageBox.hide();" Delay="1000"/>
                    </Listeners>
                    <Model>
                        <ext:Model runat="server">
                            <Fields>
                                <ext:ModelField Name="code" />
                                <ext:ModelField Name="desc" />
                                <ext:ModelField Name="id" />
                                <ext:ModelField Name="master_no" />
                            </Fields>
                        </ext:Model>
                    </Model>
                </ext:Store>
            </Store>
            <ColumnModel>
                <Columns>
                    <ext:Column runat="server" Text="Fırsat" Width="160" DataIndex="desc" Flex="1" />
                </Columns>
            </ColumnModel>
            <View>
                <ext:GridView runat="server">
                    <Plugins>
                        <ext:GridDragDrop runat="server" DragGroup="secondGridDDGroup" DropGroup="firstGridDDGroup" />
                    </Plugins>
                    <Listeners>
                        <AfterRender Handler="this.plugins[0].dragZone.getDragText = getDragDropText;" Delay="1" />
                        <Drop Handler="
                                Ext.MessageBox.show({
	                              msg: 'Islem yapilirken lutfen bekleyiniz.',
	                              progressText: 'Bekleyiniz...',
	                              width:300,
	                              wait:true,
	                              waitConfig: {interval:200}
	                            });
                                ekleSilFirsat(
                                    data.records[0].get('id'),
                                    data.records[0].get('desc'),
                                    true);
                              "/>       
                    </Listeners>
                </ext:GridView>
            </View>
        </ext:GridPanel>
    </Items>
</ext:Panel>
