<%@ Page Language="C#" UICulture="tr-TR" %>
<%@ Import Namespace="UyumSosyal" %>

<script runat="server">
    StoreReadDataEventArgs e, e2, e3;

    protected void StoreWindow_RefershData(object sender, StoreReadDataEventArgs e)
    {
        try
        {
            X.MessageBox.Show(new MessageBoxConfig()
            {
                Message = "Islem yapilirken lutfen bekleyiniz.",
                ProgressText = "Bekleyiniz...",
                Width = 300,
                Wait = true,
                WaitConfig = new WaitConfig() { Interval = 200 }
            });
            var store = (Store)sender;
            store.DataSource = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.CrmForm.GetFilterFirsatFaaliyet(0, 1000);
            store.DataBind();
        }
        catch(Exception ex)
        {
             Helper.Error("GetFilterFirsatFaaliyet'de web service hatası : " + ex.Message);
        }
    }

    protected void Store1_RefreshData(object sender, StoreReadDataEventArgs e)
    {
        this.e = e;
        this.Store1.DataBind();
    }

    protected void ObjectSelecting(object sender, ObjectDataSourceSelectingEventArgs e)
    {
        var t1 = DateTime.Now.AddDays(-1);
        var t2 = DateTime.Now;

        try
        {
            t1 = (DateTime)DateField1.Value;
        }
        catch
        {
        }

        try
        {
            t2 = (DateTime)DateField2.Value;
        }
        catch
        {
        }
        e.InputParameters["start"] = this.e.Start;
        e.InputParameters["limit"] = this.e.Limit;
        e.InputParameters["sort"] = this.e.Sort[0];
        e.InputParameters["arax"] = TextFieldArama.Text;
        e.InputParameters["bas"] = t1;
        e.InputParameters["bit"] = t2;
    }

    protected void Store2_RefreshData(object sender, StoreReadDataEventArgs e)
    {
        this.e2 = e;
        this.Store2.DataBind();
    }

    protected void Store3_RefreshData(object sender, StoreReadDataEventArgs e)
    {
        this.e3 = e;
        this.Store3.DataBind();
    }

    protected void ObjectSelectingFirsat(object sender, ObjectDataSourceSelectingEventArgs e)
    {
        e.InputParameters["start"] = this.e2.Start;
        e.InputParameters["limit"] = this.e2.Limit;
        e.InputParameters["sort"] = this.e2.Sort[0];
        e.InputParameters["arax"] = TextFieldArama.Text;
    }

    protected void ObjectSelectingCagri(object sender, ObjectDataSourceSelectingEventArgs e)
    {
        e.InputParameters["start"] = this.e3.Start;
        e.InputParameters["limit"] = this.e3.Limit;
        e.InputParameters["sort"] = this.e3.Sort[0];
        e.InputParameters["arax"] = TextFieldArama.Text;
    }

    protected void ObjectDataSource1_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        (this.Store1.Proxy[0] as PageProxy).Total = (int)e.OutputParameters["count"];
    }

    protected void ObjectDataSourceFirsat_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        (this.Store2.Proxy[0] as PageProxy).Total = (int)e.OutputParameters["count"];
    }

    protected void ObjectDataSourceCagri_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        (this.Store3.Proxy[0] as PageProxy).Total = (int)e.OutputParameters["count"];
    }

    [DirectMethod]
    public void PostDetaySec(int master_no)
    {
        Session["secilenCrmFormIslemleri"] = master_no.ToString();
    }

    [DirectMethod]
    public void FirsatEkrani(string kod)
    {
        Session["secilenCrmFormIslemleriFirsat"] = kod;
        StoreL.Reload();
        PickWindowFirsat.Show();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["user"] == null)
        {
            Response.Write("<script type='text/javascript'>");
            Response.Write("top.document.location.href='../../../../Login.aspx';");
            Response.Write("<" + "/" + "script>");
            Response.End();
            return;
        }

        if (!X.IsAjaxRequest)
        {
            DateField1.Value = DateTime.Now.AddDays(-1);
            DateField2.Value = DateTime.Now;
        }
    }
</script>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title>Crm From İşlemleri</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        var keyHandler = function (k, e) {
            if (e.getKey() == 13) {
                Ext.getCmp('GridPanel1').getStore().load();
            }
        };
        var secDetay = function (master_id) {
            CompanyX.PostDetaySec(master_id);
            Ext.getCmp('GridPanel2').getStore().load();
            Ext.getCmp('GridPanel3').getStore().load();
        };
        var onCommand = function (column, command, record, recordIndex, cellIndex) {
            var fk = record.data.firsat_kod;
            CompanyX.FirsatEkrani(fk);
        };
    </script> 

    <style type="text/css">
        .x-grid-cell-fullName .x-grid-cell-inner {
            font-family : tahoma, verdana;
            display     : block;
            font-weight : normal;
            font-style  : normal;
            color       : #385F95;
            white-space : normal;
        }
        
        .x-grid-rowbody div {
            margin : 2px 5px 20px 5px !important;
            width  : 99%;
            color  : Gray;
        }
        
        .x-grid-row-expanded td.x-grid-cell{
            border-bottom-width:0px;
        }
    </style>
</head>
<body>
<form id="Form1" runat="server">
<ext:ResourceManager ID="ResourceManager1" runat="server" DirectMethodNamespace="CompanyX">
    <Listeners>               
    </Listeners>
</ext:ResourceManager>
        
<asp:ObjectDataSource 
    ID="ObjectDataSource1" 
    runat="server"
    OnSelecting="ObjectSelecting"
    OnSelected="ObjectDataSource1_Selected"
    SelectMethod="GetFilter"
    TypeName="UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.CrmForm">
    <SelectParameters>
        <asp:Parameter Name="start" Type="Int32" />
        <asp:Parameter Name="limit" Type="Int32" />
        <asp:Parameter Name="sort" Type="Object" />                
        <asp:Parameter Name="count" Direction="Output" Type="Int32" />
        <asp:Parameter Name="arax" Type="String" />
        <asp:Parameter Name="bas" Type="DateTime" />
        <asp:Parameter Name="bit" Type="DateTime" />
    </SelectParameters>
</asp:ObjectDataSource>
        
<asp:ObjectDataSource 
    ID="ObjectDataSource2" 
    runat="server"
    OnSelecting="ObjectSelectingFirsat"
    OnSelected="ObjectDataSourceFirsat_Selected"
    SelectMethod="GetFilterFirsat"
    TypeName="UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.CrmForm">
    <SelectParameters>
        <asp:Parameter Name="start" Type="Int32" />
        <asp:Parameter Name="limit" Type="Int32" />
        <asp:Parameter Name="sort" Type="Object" />                
        <asp:Parameter Name="count" Direction="Output" Type="Int32" />
        <asp:Parameter Name="arax" Type="String" />
    </SelectParameters>
</asp:ObjectDataSource>
        
<asp:ObjectDataSource 
    ID="ObjectDataSource3" 
    runat="server"
    OnSelecting="ObjectSelectingCagri"
    OnSelected="ObjectDataSourceCagri_Selected"
    SelectMethod="GetFilterCagri"
    TypeName="UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.CrmForm">
    <SelectParameters>
        <asp:Parameter Name="start" Type="Int32" />
        <asp:Parameter Name="limit" Type="Int32" />
        <asp:Parameter Name="sort" Type="Object" />                
        <asp:Parameter Name="count" Direction="Output" Type="Int32" />
        <asp:Parameter Name="arax" Type="String" />
    </SelectParameters>
</asp:ObjectDataSource>

<asp:HiddenField ID="gizli" runat="server" Value="" />
        
<ext:Window ID="PickWindowFirsat" runat="server" Width="1000" Height="410" AutoHeight="true" Title="Fırsat Faaliyet"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Form">
    <Items>
                
        <ext:GridPanel
            ID="GridPanel4"
            runat="server"
            MultiSelect="false"
            Flex="1"
            MarginSpec="0 0 0 0">
            <Store>
                <ext:Store ID="StoreL" OnReadData="StoreWindow_RefershData" runat="server">
                    <Listeners>
                        <Load Handler="Ext.MessageBox.hide();" Delay="1000"/>
                    </Listeners>
                    <Model>
                        <ext:Model runat="server">
                            <Fields>
                                <ext:ModelField Name="faaliyet_tarih" />
                                <ext:ModelField Name="musteri" />
                                <ext:ModelField Name="musteri_ad" />
                                <ext:ModelField Name="iliski_tur" />
                                <ext:ModelField Name="aciklama" />
                                <ext:ModelField Name="kullanici" />
                                <ext:ModelField Name="id" />
                                <ext:ModelField Name="_count" />
                            </Fields>
                        </ext:Model>
                    </Model>
                </ext:Store>
            </Store>
            <ColumnModel>
                <Columns>
                    <ext:Column runat="server" Text="F.Tarih" Width="120" DataIndex="faaliyet_tarih" />
                    <ext:Column runat="server" Text="Müşteri" Width="160" DataIndex="musteri" />
                    <ext:Column runat="server" Text="Müşteri Ad" Width="160" DataIndex="musteri_ad" />
                    <ext:Column runat="server" Text="İ.Tür" Width="80" DataIndex="iliski_tur" />
                    <ext:Column runat="server" Text="Açıklama" Width="260" DataIndex="aciklama" />
                    <ext:Column runat="server" Text="Kullanıcı" Width="200" DataIndex="kullanici" />
                </Columns>
            </ColumnModel>
        </ext:GridPanel>

    </Items>
    <Buttons>
        <ext:Button ID="ButtonVazgec" runat="server" Text="Kapat" Icon="Door">
            <Listeners>
                <Click Handler="#{PickWindowFirsat}.hide();" />
            </Listeners>
        </ext:Button>

    </Buttons>  
</ext:Window>

<ext:Viewport ID="Viewport1" Layout="BorderLayout" runat="server">
<Items>

<ext:Panel
    ID="Panel1"
    runat="server"
    Region="North"
    BodyPadding="5"
    Frame="true"
    Layout="Fit"
    Height="300"
    Split="true"
    MarginSpec="5 5 5 5">
    <Items>
        <ext:GridPanel ID="GridPanel1"
                       runat="server">                            
            <TopBar>
                <ext:Toolbar ID="Toolbar3" runat="server">
                    <Items>
                                        
                        <ext:TextField 
                            ID="TextFieldArama" 
                            runat="server"
                            EnableKeyEvents="true"
                            LabelWidth="40"
                            FieldLabel="Arama"                                            
                            InputType="Text"
                            Width="170">
                            <Listeners>
                                <KeyUp Delay="100" Fn="keyHandler" />
                            </Listeners>
                        </ext:TextField>

                        <ext:ToolbarSeparator />
                                        
                        <ext:DateField 
                            ID="DateField1" 
                            runat="server"
                            Width="220"
                            LabelWidth="80"
                            Vtype="daterange"
                            Editable="false"
                            FieldLabel="Baş.Tarihi">  
                            <Listeners>
                            </Listeners>
                        </ext:DateField>    

                        <ext:DateField 
                            ID="DateField2" 
                            runat="server"
                            Width="220"
                            LabelWidth="80"
                            Vtype="daterange"
                            Editable="false"
                            FieldLabel="Bit.Tarihi">  
                            <Listeners>
                            </Listeners>
                        </ext:DateField>
                                        
                        <ext:Button ID="Button3" runat="server" Enabled="true" Text="Ara" Icon="Find">
                            <Listeners>
                                <Click Delay="100" Handler = "
                                                            Ext.getCmp('GridPanel1').getStore().load();
                                                            #{TextFieldArama}.focus(false, 200);
                                                    "/>
                            </Listeners>
                        </ext:Button>
                        
                        <ext:ToolbarSeparator />
                        
                        <ext:Label runat="server" Text="Kolonlara tıklayarak sıralama yapabilirsiniz, son seçilen kolona göre arama yapabilirsiniz."></ext:Label>

                    </Items> 
                </ext:Toolbar>
            </TopBar>
            <Store>
                <ext:Store 
                    ID="Store1" 
                    runat="server" 
                    DataSourceID="ObjectDataSource1"
                    RemoteSort="true"
                    OnReadData="Store1_RefreshData"
                    PageSize="23">
                    <AutoLoadParams>
                        <ext:Parameter Name="start" Value="0" Mode="Raw" />
                        <ext:Parameter Name="limit" Value="99999" Mode="Raw" />
                    </AutoLoadParams>
                    <Proxy>
                        <ext:PageProxy />
                    </Proxy>
                    <Model>
                        <ext:Model ID="Model1" runat="server" IDProperty="ids">
                            <Fields>
                                <ext:ModelField Name="id" />
                                <ext:ModelField Name="form_ad" />
                                <ext:ModelField Name="tip" />
                                <ext:ModelField Name="yetkili_kisi" />
                                <ext:ModelField Name="firma_tel" />
                                <ext:ModelField Name="firma_email" />
                                <ext:ModelField Name="aciklama" />
                                <ext:ModelField Name="firma_web" />
                                <ext:ModelField Name="cari_kod" />
                                <ext:ModelField Name="cari_ad" />
                                <ext:ModelField Name="kapali" />
                                <ext:ModelField Name="geldigi_kanal" />
                                <ext:ModelField Name="master_no" />
                                <ext:ModelField Name="faaliyet_yili" />
                                <ext:ModelField Name="create_date" />
                            </Fields>
                        </ext:Model>
                    </Model>
                    <Sorters>
                        <ext:DataSorter Property="tip" Direction="ASC" />
                    </Sorters>
                </ext:Store>
            </Store>
            <ColumnModel ID="ColumnModel1" runat="server">
                <Columns>
                    <ext:Column ID="Kod" runat="server" Text="Faaliyet Yılı" DataIndex="faaliyet_yili" Sortable="true" Width="130" />
                    <ext:Column ID="Column23" runat="server" Text="Oluşturma Tarihi" DataIndex="create_date" Sortable="false" Width="130" />
                    <ext:Column ID="Column22" runat="server" Text="Form Ad" DataIndex="form_ad" Sortable="true" Width="130" />
                    <ext:Column ID="Column3" runat="server" Text="Tip" DataIndex="tip" Width="200" />
                    <ext:Column ID="Column4" runat="server" Text="Yetkili Kişi" DataIndex="yetkili_kisi" Width="130" />
                    <ext:Column ID="Column1" runat="server" Text="Firma Tel" DataIndex="firma_tel" Width="130" />
                    <ext:Column ID="Column2" runat="server" Text="Firma Mail" DataIndex="firma_email" Width="200" />
                    <ext:Column ID="Column5" runat="server" Text="Açıklama" DataIndex="aciklama" Width="400" />
                    <ext:Column ID="Column6" runat="server" Text="Firma Web" DataIndex="firma_web" Width="200" />
                    <ext:Column ID="Column7" runat="server" Text="Cari Kod" DataIndex="cari_kod" Width="200" />
                    <ext:Column ID="Column8" runat="server" Text="Cari Ad" DataIndex="cari_ad" Width="400" />
                    <ext:Column ID="Column16" runat="server" Text="Durum" DataIndex="kapali" Width="100" />
                    <ext:Column ID="Column17" runat="server" Text="Geldiği Kanal" DataIndex="geldigi_kanal" Width="200" />
                </Columns>
            </ColumnModel>
            <View>
                <ext:GridView ID="GridView1" runat="server">
                    <GetRowClass Handler="return 'x-grid-row-expanded';" />
                </ext:GridView>        
            </View>
            <SelectionModel>
                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single" />
            </SelectionModel>
            <Listeners>
                <Activate Handler="#{Toolbar2}.show();" Delay="1" />
                <Select Handler="
                                    var v= #{GridPanel1}.getSelectionModel().getSelection();
                                    if (v.length>0) { 
                                        #{gizli}.setValue(v[0].data.master_no); 
                                        secDetay(v[0].data.master_no);
                                    }
                                    else {
                                        #{gizli}.setValue('');
                                        secDetay(0);
                                    }
                                    "/>
            </Listeners>
            <BottomBar>
                <%-- ext:PagingToolbar ID="PagingToolbar1" 
                                   runat="server" 
                                   PageSize="99999" 
                                   StoreID="Store1" 
                                   DisplayInfo="true" 
                                   DisplayMsg="Gösterilen {0} - {1} / {2}" 
                                   EmptyMsg="Kayıt yok."
                / --%>
            </BottomBar>
            <Features>
                <ext:RowBody ID="RowBody1" runat="server" >
                </ext:RowBody>
            </Features>                            
        </ext:GridPanel>
    </Items>
</ext:Panel>
               
<ext:TabPanel
    runat="server"
    Region="Center"
    Frame="true"
    Layout="Fit"
    MarginSpec="0 5 0 5">
    <Items>
        <ext:GridPanel ID="GridPanel2"
                       runat="server" Title="Fırsat Detayları"
                       Frame="true"
                       Height="600">
            <Store>

                <ext:Store 
                    ID="Store2" 
                    runat="server" 
                    DataSourceID="ObjectDataSource2"
                    RemoteSort="true"
                    OnReadData="Store2_RefreshData"
                    PageSize="23">
                    <AutoLoadParams>
                        <ext:Parameter Name="start" Value="0" Mode="Raw" />
                        <ext:Parameter Name="limit" Value="23" Mode="Raw" />
                    </AutoLoadParams>
                    <Proxy>
                        <ext:PageProxy />
                    </Proxy>
                    <Model>
                        <ext:Model ID="Model2" runat="server" IDProperty="ids">
                            <Fields>
                                <ext:ModelField Name="firsat_kod" />
                                <ext:ModelField Name="firsat_Ad" />
                                <ext:ModelField Name="cari_kod" />
                                <ext:ModelField Name="cari_ad" />
                                <ext:ModelField Name="firsat_tarih" />
                                <ext:ModelField Name="firsat_statu" />
                                <ext:ModelField Name="firsati_takip_eden" />
                                <ext:ModelField Name="_count" />
                                <ext:ModelField Name="id" />
                            </Fields>
                        </ext:Model>
                    </Model>
                    <Sorters>
                        <ext:DataSorter Property="cari_kod" Direction="ASC" />
                    </Sorters>
                </ext:Store>

            </Store>
            <ColumnModel ID="ColumnModel2" runat="server">
                <Columns>
                    <ext:Column ID="Column9" runat="server" Text="Fırsat Kod" DataIndex="firsat_kod" Sortable="true" Width="130">
                        <Commands>
                            <ext:ImageCommand CommandName="FirsatKodAra" Icon="ApplicationCascade" />
                        </Commands>
                        <Listeners>
                            <Command Fn="onCommand" />
                        </Listeners>
                    </ext:Column>
                    <ext:Column ID="Column10" runat="server" Text="Fırsat Ad" DataIndex="firsat_Ad" Width="200" />
                    <ext:Column ID="Column11" runat="server" Text="Cari Kod" DataIndex="cari_kod" Width="130" />
                    <ext:Column ID="Column12" runat="server" Text="Cari Ad" DataIndex="cari_ad" Width="130" />
                    <ext:Column ID="Column13" runat="server" Text="Fırsat Tarih" DataIndex="firsat_tarih" Width="200" />
                    <ext:Column ID="Column14" runat="server" Text="Fırsat Statü" DataIndex="firsat_statu" Width="200" />
                    <ext:Column ID="Column15" runat="server" Text="F.Takip Eden" DataIndex="firsati_takip_eden" Width="200" />
                </Columns>
            </ColumnModel>
            <View>
                <ext:GridView ID="GridView2" runat="server">
                    <GetRowClass Handler="return 'x-grid-row-expanded';" />
                </ext:GridView>        
            </View>
                              
            <SelectionModel>
                <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" Mode="Single" />
            </SelectionModel>
                            
            <BottomBar>
                <ext:PagingToolbar ID="PagingToolbar2" 
                                   runat="server" 
                                   PageSize="23" 
                                   StoreID="Store2" 
                                   DisplayInfo="true" 
                                   DisplayMsg="Gösterilen {0} - {1} / {2}" 
                                   EmptyMsg="Kayıt yok."
                />
            </BottomBar>
            <Features>
                <ext:RowBody ID="RowBody2" runat="server" >
                </ext:RowBody>
            </Features>                            
        </ext:GridPanel>
                        
        <ext:GridPanel ID="GridPanel3" 
                       runat="server" Title="Çağrı Detayları"
                       Frame="true"
                       Height="600">
            <Store>
                <ext:Store 
                    ID="Store3" 
                    runat="server" 
                    DataSourceID="ObjectDataSource3"
                    RemoteSort="true"
                    OnReadData="Store3_RefreshData"
                    PageSize="23">
                    <AutoLoadParams>
                        <ext:Parameter Name="start" Value="0" Mode="Raw" />
                        <ext:Parameter Name="limit" Value="23" Mode="Raw" />
                    </AutoLoadParams>
                    <Proxy>
                        <ext:PageProxy />
                    </Proxy>
                    <Model>
                        <ext:Model ID="Model3" runat="server" IDProperty="ids">
                            <Fields>
                                <ext:ModelField Name="belge_tarih" />
                                <ext:ModelField Name="cari_kod" />
                                <ext:ModelField Name="cagri_konusu" />
                                <ext:ModelField Name="aciklama1" />
                                <ext:ModelField Name="id" />
                                <ext:ModelField Name="_count" />
                            </Fields>
                        </ext:Model>
                    </Model>
                    <Sorters>
                        <ext:DataSorter Property="cari_kod" Direction="ASC" />
                    </Sorters>
                </ext:Store>

            </Store>
            <ColumnModel ID="ColumnModel3" runat="server">
                <Columns>
                    <ext:Column ID="Column18" runat="server" Text="Belge Tarih" DataIndex="belge_tarih" Sortable="true" Width="130" />
                    <ext:Column ID="Column19" runat="server" Text="Cari Kod" DataIndex="cari_kod" Width="130" />
                    <ext:Column ID="Column20" runat="server" Text="Çağrı Konusu" DataIndex="cagri_konusu" Width="200" />
                    <ext:Column ID="Column21" runat="server" Text="Açıklama" DataIndex="aciklama1" Width="600" />
                </Columns>
            </ColumnModel>
            <View>
                <ext:GridView ID="GridView3" runat="server">
                    <GetRowClass Handler="return 'x-grid-row-expanded';" />
                </ext:GridView>        
            </View>
                              
            <SelectionModel>
                <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" Mode="Single" />
            </SelectionModel>
                            
            <BottomBar>
                <ext:PagingToolbar ID="PagingToolbar3" 
                                   runat="server" 
                                   PageSize="23" 
                                   StoreID="Store3" 
                                   DisplayInfo="true" 
                                   DisplayMsg="Gösterilen {0} - {1} / {2}" 
                                   EmptyMsg="Kayıt yok."
                />
            </BottomBar>
            <Features>
                <ext:RowBody ID="RowBody3" runat="server" >
                </ext:RowBody>
            </Features>                            
        </ext:GridPanel>

    </Items>
</ext:TabPanel>

</Items>
</ext:Viewport>  

</form>
</body>
</html>
