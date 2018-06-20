<%@ Page Language="C#" UICulture="tr-TR" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="UyumSosyal" %>

<script runat="server">
    StoreReadDataEventArgs e;

    protected void Store1_RefreshData(object sender, StoreReadDataEventArgs e)
    {
        this.e = e;
        this.Store1.DataBind();
    }

    protected void ObjectSelecting(object sender, ObjectDataSourceSelectingEventArgs e)
    {
        e.InputParameters["start"] = this.e.Start;
        e.InputParameters["limit"] = this.e.Limit;
        e.InputParameters["sort"] = this.e.Sort[0];
        e.InputParameters["arax"] = TextFieldArama.Text;
    }

    protected void ObjectDataSource1_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        (this.Store1.Proxy[0] as PageProxy).Total = (int)e.OutputParameters["count"];
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
    }

    protected void DetayEkraniAc(object sender, DirectEventArgs e)
    {

        if (gizli.Value == "")
        {
            X.MessageBox.Hide();
            X.Msg.Alert("Dikkat", "Lütfen Hedef Kitle Seçiniz!").Show();
            return;
        }

        Session["secilen"] = gizli.Value;
        TabPanelDetail.SetActiveTab(4);
        TabPanelDetail.SetActiveTab(0);
        X.MessageBox.Hide();
        PickWindowDetailForm.Show();
    }

    protected void ButtonSave(object sender, DirectEventArgs e)
    {
        if (TextFieldListeId.Text.Trim().Length < 1)
        {
            X.Msg.Alert("Dikkat", "Liste Id boş bırakılamaz!").Show();
            return;
        }

        if (TextFieldListeAd.Text.Trim().Length < 1)
        {
            X.Msg.Alert("Dikkat", "Liste Ad boş bırakılamaz!").Show();
            return;
        }

        if (string.IsNullOrEmpty(ComboBoxSosyal.SelectedItem.Value))
        {
            X.Msg.Alert("Dikkat", "Lütfen Tip seçiniz!").Show();
            return;
        }

        try
        {
            var err = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.HedefKitleM.Save(
                gizli.Value, // ekle ise boş düzelt ise dolu gelir
                TextFieldListeId.Text.Trim(),
                TextFieldListeAd.Text.Trim(),
                TextFieldAciklama.Text.Trim(),
                ComboBoxSosyal.SelectedItem.Value);
            if (err != "ok")
            {
                X.Msg.Alert("Dikkat", err).Show();
                return;
            }

            // tazele
            Store1.Reload();
            gizli.Value = "";
            TextFieldListeId.Text = "";
            TextFieldListeAd.Text = "";
            TextFieldAciklama.Text = "";
            PickWindowFormAdd.Hide();
        }
        catch(Exception ex)
        {
            Helper.Error("HedefKitleMasterKaydet'de web service hatası : " + ex.Message);
        }
    }

    [DirectMethod]
    public void PostFirsatIsle(int id, string firsat, bool isEkle)
    {
        var ret = "ok";
        if (isEkle)
        {
            try
            {
                if (Session["secilen"] == null)
                {
                    ret = "Seçim yapılmamış.";
                }
                ret = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.FirsatSariAlanListesi.Add(Session["secilen"].ToString().ToInt(), firsat);
            }
            catch(Exception ex)
            {
                Helper.Error("HedefKitleFirsatSil'de web service hatası : " + ex.Message);
            }
        }
        else
        {
            if (id == 0)
            {
                ; // sifir gelme soldaki sehir isimlerinin id'sinin eklenmediği için sıfırdan başladığından dolayı
            }
            try
            {
                var buldu = false;
                var liste = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.FirsatSariAlanListesi.GetFilterR(0, 1000);
                foreach (var l in liste)
                {
                    if (l.desc != firsat) continue;
                    buldu = true;
                    id = l.id;
                    break;
                }
                if (!buldu || id == 0)
                {
                    ret = "Ekrandan fırsat bilgisi alınamadı, ekranı kapatıp tekrar demeyimiz.";
                }
                ret = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.FirsatSariAlanListesi.Remove(id);
            }
            catch(Exception ex)
            {
                Helper.Error("HedefKitleFirsatListe veya HedefKitleFirsatSil'de web service hatası : " + ex.Message);
            }
        }

        X.MessageBox.Hide();
        if (ret != "ok")
        {
            X.Msg.Show(new MessageBoxConfig
            {
                Title = "Dikkat",
                Message = ret,
                Buttons = MessageBox.Button.OK,
                Icon = MessageBox.Icon.ERROR
            });
        }
    }

    [DirectMethod]
    public void PostUrunIsle(int id, string urun, bool isEkle)
    {
        var ret = "ok";
        if (isEkle)
        {
            if (Session["secilen"] == null)
            {
                ret = "Seçim yapılmamış.";
            }
            try
            {
                ret = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.UrunSariAlanListesi.Add(Session["secilen"].ToString().ToInt(), urun);
            }
            catch(Exception ex)
            {
                Helper.Error("HedefKitleUrunKaydet'de web service hatası : " + ex.Message);
            }
        }
        else
        {
            if (id == 0)
            {
                ; // sifir gelme soldaki sehir isimlerinin id'sinin eklenmediği için sıfırdan başladığından dolayı
            }
            var buldu = false;
            try
            {
                var liste = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.UrunSariAlanListesi.GetFilterR(0, 1000);
                foreach (var l in liste)
                {
                    if (l.desc != urun) continue;
                    buldu = true;
                    id = l.id;
                    break;
                }
                if (!buldu || id == 0)
                {
                    ret = "Ekrandan ürün bilgisi alınamadı, ekranı kapatıp tekrar demeyimiz.";
                }
                ret = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.UrunSariAlanListesi.Remove(id);
            }
            catch(Exception ex)
            {
                Helper.Error("HedefKitleUrunListe veya HedefKitleUrunSil'de web service hatası : " + ex.Message);
            }
        }

        X.MessageBox.Hide();
        if (ret != "ok")
        {
            X.Msg.Show(new MessageBoxConfig
            {
                Title = "Dikkat",
                Message = ret,
                Buttons = MessageBox.Button.OK,
                Icon = MessageBox.Icon.ERROR
            });
        }
    }

    [DirectMethod]
    public void PostSetorIsle(int id, string sektor, bool isEkle)
    {
        var ret = "ok";
        if (isEkle)
        {
            if (Session["secilen"] == null)
            {
                ret = "Seçim yapılmamış.";
            }
            try
            {
                ret = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.SektorSariAlanListesi.Add(Session["secilen"].ToString().ToInt(), sektor);
            }
            catch(Exception ex)
            {
                Helper.Error("HedefKitleSektorKaydet'de web service hatası : " + ex.Message);
            }
        }
        else
        {
            if (id == 0)
            {
                ; // sifir gelme soldaki sehir isimlerinin id'sinin eklenmediği için sıfırdan başladığından dolayı
            }
            var buldu = false;
            try
            {
                var liste = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.SektorSariAlanListesi.GetFilterR(0, 1000);
                foreach (var l in liste)
                {
                    if (l.code != sektor) continue;
                    buldu = true;
                    id = l.id;
                    break;
                }
                if (!buldu || id == 0)
                {
                    ret = "Ekrandan sektör bilgisi alınamadı, ekranı kapatıp tekrar demeyimiz.";
                }
                ret = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.SektorSariAlanListesi.Remove(id);
            }
            catch(Exception ex)
            {
                Helper.Error("HedefKitleSektorListe veya HedefKitleSektorSil'de web service hatası : " + ex.Message);
            }
        }

        X.MessageBox.Hide();
        if (ret != "ok")
        {
            X.Msg.Show(new MessageBoxConfig
            {
                Title = "Dikkat",
                Message = ret,
                Buttons = MessageBox.Button.OK,
                Icon = MessageBox.Icon.ERROR
            });
        }
    }

    [DirectMethod]
    public void PostSehirIsle(int id, string sehir, bool isEkle)
    {
        var ret = "ok";
        if (isEkle)
        {
            if (Session["secilen"] == null)
            {
                ret = "Seçim yapılmamış.";
            }
            try
            {
                ret = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.SehirSariAlanListesi.Add(Session["secilen"].ToString().ToInt(), sehir);
            }
            catch(Exception ex)
            {
                Helper.Error("HedefKitleSehirKaydet'de web service hatası : " + ex.Message);
            }
        }
        else
        {
            if (id == 0)
            {
                ; // sifir gelme soldaki sehir isimlerinin id'sinin eklenmediği için sıfırdan başladığından dolayı
            }
            var buldu = false;
            try
            {
                var liste = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.SehirSariAlanListesi.GetFilterR(0, 1000);
                foreach (var l in liste)
                {
                    if (l.desc != sehir) continue;
                    buldu = true;
                    id = l.id;
                    break;
                }
                if (!buldu || id == 0)
                {
                    ret = "Ekrandan sehir bilgisi alınamadı, ekranı kapatıp tekrar demeyimiz.";
                }
                ret = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.SehirSariAlanListesi.Remove(id);
            }
            catch(Exception ex)
            {
                Helper.Error("HedefKitleSehirListe veya HedefKitleSehirSil'de web service hatası : " + ex.Message);
            }
        }

        X.MessageBox.Hide();
        if (ret != "ok")
        {
            X.Msg.Show(new MessageBoxConfig
            {
                Title = "Dikkat",
                Message = ret,
                Buttons = MessageBox.Button.OK,
                Icon = MessageBox.Icon.ERROR
            });
        }
    }

    [DirectMethod(Namespace = "CompanyX", Timeout = 300000)]
    public void Sil(int kkod)
    {
        try
        {
            var don = UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.HedefKitleM.Remove(kkod);
            X.MessageBox.Hide();
            if (don != "ok")
            {
                X.Msg.Alert("Dikkat", don).Show();
            }
            else
            {
                // tazele
                Store1.Reload();
                gizli.Value = "";
                lbUser.Text = "Seçilen Kitle : Yok!";
            }
        }
        catch(Exception ex)
        {
            Helper.Error("HedefKitleMasterSil'de web service hatası : " + ex.Message);
        }
        finally
        {
            X.MessageBox.Hide();
        }
    }
</script>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title>Hedef Kitle</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        var showResult = function (btn) {
            if (btn == 'Yes' || btn == 'yes' || btn == 'Evet' || btn == 'evet') {
                var v = Ext.getCmp('GridPanel1').getSelectionModel().getSelection();

                Ext.MessageBox.show({
                    msg: 'Islem yapilirken lutfen bekleyiniz.',
                    progressText: 'Bekleyiniz...',
                    width: 300,
                    wait: true,
                    waitConfig: { interval: 200 }
                });

                CompanyX.Sil(v[0].data.master_no);
            }
        };
        
        var ekleSilFirsat = function (id, firsat, isEkle) {
            CompanyX.PostFirsatIsle(id, firsat, isEkle);
        };
        var ekleSilUrun = function (id, sektor, isEkle) {
            CompanyX.PostUrunIsle(id, sektor, isEkle);
        };
        var ekleSilSektor = function (id, sektor, isEkle) {
            CompanyX.PostSetorIsle(id, sektor, isEkle);
        };
        var ekleSilSehir = function (id, sehir, isEkle) {
            CompanyX.PostSehirIsle(id, sehir, isEkle);
        };
        var keyHandler = function (k, e) {
            if (e.getKey() == 13) {
                Ext.getCmp('GridPanel1').getStore().load();
            }
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
            TypeName="UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared.HedefKitleM">
            <SelectParameters>
                <asp:Parameter Name="start" Type="Int32" />
                <asp:Parameter Name="limit" Type="Int32" />
                <asp:Parameter Name="sort" Type="Object" />                
                <asp:Parameter Name="count" Direction="Output" Type="Int32" />
                <asp:Parameter Name="arax" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>

        <asp:HiddenField ID="gizli" runat="server" Value="" />
    
        <ext:Window ID="PickWindowDetailForm" runat="server" Width="800" Height="510" AutoHeight="true" Title="Detay"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="1"
            LabelWidth="125" Layout="Form">
            <Items>
                <ext:TabPanel
                    runat="server"
                    Border="false"
                    ID="TabPanelDetail"
                    BodyPadding="1">
                    <Defaults>
                        <ext:Parameter Name="bodyPadding" Value="20" Mode="Raw" />
                    </Defaults>
                    <Items>
                        <ext:Panel runat="server" Title="Şehir">
                            <Listeners>
                                <Activate Handler="#{StoreL}.reload();#{StoreR}.reload();" Delay="1" />
                            </Listeners>
                            <Items>
                                <ext:UserControlLoader runat="server" Path="Sehir.ascx" />
                            </Items>
                        </ext:Panel>
                        <ext:Panel runat="server" Title="Sektör">
                            <Listeners>
                                <Activate Handler="#{StoreSektorL}.reload();#{StoreSektorR}.reload();" Delay="1" />
                            </Listeners>
                            <Items>
                                <ext:UserControlLoader runat="server" Path="Sektor.ascx" />
                            </Items>
                        </ext:Panel>
                        <ext:Panel runat="server" Title="Ürünler">
                            <Listeners>
                                <Activate Handler="#{StoreUrunL}.reload();#{StoreUrunR}.reload();" Delay="1" />
                            </Listeners>
                            <Items>
                                <ext:UserControlLoader runat="server" Path="Urun.ascx" />
                            </Items>
                        </ext:Panel>
                        <ext:Panel runat="server" Title="Fırsat">
                            <Listeners>
                                <Activate Handler="#{StoreFirsatL}.reload();#{StoreFirsatR}.reload();" Delay="1" />
                            </Listeners>
                            <Items>
                                <ext:UserControlLoader runat="server" Path="Firsat.ascx" />
                            </Items>
                        </ext:Panel>
                        <ext:Panel runat="server" Title="Dahil Kategoriler" Html=".NET Framework" />
                        <ext:Panel runat="server" Title="Hariç Kategoriler" Html=".NET Framework" />
                        <ext:Panel runat="server" Title="Ünvan" Html=".NET Framework" />
                    </Items>
                </ext:TabPanel>
            </Items>
            <Buttons>

                <ext:Button ID="Button3" runat="server" Text="Kapat" Icon="Door">
                    <Listeners>
                        <Click Handler="#{PickWindowDetailForm}.hide();" />
                    </Listeners>
                </ext:Button>

            </Buttons>  
        </ext:Window>

        <ext:Window ID="PickWindowFormAdd" runat="server" Width="300" Height="310" AutoHeight="true" Title="Ekle"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Form">
            <Items>
                
                <ext:TextField ID="TextFieldListeId" runat="server" ReadOnly="false" InputType="Text"
                    FieldLabel="Liste Id" LabelWidth="50" Width="120" AllowBlank="false" BlankText="Liste Id boş geçilemez!" MaxLengthText="50"
                    Text="" EnableKeyEvents="true">
                    <Listeners>
                        <KeyPress Handler="if(e.getKey() == e.ENTER || e.getKey() == e.RETURN) { #{TextFieldListeAd}.focus(); }" />
                    </Listeners>
                </ext:TextField>
                
                <ext:TextField ID="TextFieldListeAd" runat="server" ReadOnly="false" InputType="Text"
                               FieldLabel="Liste Ad" LabelWidth="50" Width="120" AllowBlank="false" BlankText="Liste Ad boş geçilemez!" MaxLengthText="50"
                               Text="" EnableKeyEvents="true">
                    <Listeners>
                        <KeyPress Handler="if(e.getKey() == e.ENTER || e.getKey() == e.RETURN) { #{TextFieldAciklama}.focus(); }" />
                    </Listeners>
                </ext:TextField>

                <ext:TextField ID="TextFieldAciklama" runat="server" ReadOnly="false" InputType="Text"
                               FieldLabel="Açıklama" LabelWidth="50" Width="120" AllowBlank="true" BlankText="Açıklama" MaxLengthText="100"
                               Text="" EnableKeyEvents="true">
                    <Listeners>
                        <KeyPress Handler="if(e.getKey() == e.ENTER || e.getKey() == e.RETURN) { #{TextFieldFormAd}.focus(); }" />
                    </Listeners>
                </ext:TextField>

                <ext:ComboBox ID="ComboBoxSosyal"
                              runat="server" 
                              Editable="false"
                              Selectable="True"
                              FieldLabel="Tip"
                              TriggerAction="All"
                              QueryMode="Local">
                    <Items>
                        <ext:ListItem Text="Telefon" />
                        <ext:ListItem Text="Mail" />
                    </Items>
                </ext:ComboBox>

            </Items>
            <Buttons>

                <ext:Button ID="ButtonTamam" runat="server" Text="Tamam" Icon="Accept">
                    <DirectEvents>
                        <Click OnEvent="ButtonSave">
                            <EventMask ShowMask="true" Msg="Kontrol ediliyor..." MinDelay="500" />
                        </Click>
                    </DirectEvents>
                </ext:Button>
                <ext:Button ID="ButtonVazgec" runat="server" Text="Vazgeç" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{PickWindowFormAdd}.hide();" />
                    </Listeners>
                </ext:Button>

            </Buttons>  
        </ext:Window> 

        <ext:Viewport ID="Viewport1" Layout="BorderLayout" runat="server">
            <Items> 
                <ext:Panel ID="Panel2" runat="server" Region="Center" Height="300" Header="false" Layout="Fit">
                    
                    <TopBar>
                        
                        <ext:Toolbar ID="Toolbar2" runat="server">
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
                                
                                <ext:ToolbarSeparator/>

                                <ext:Button ID="BntSave" runat="server" Enabled="true" Text="Ekle" Icon="ApplicationAdd">
                                    <Listeners>
                                        <Click Handler="
                                            #{gizli}.setValue(''); 
                                            #{lbUser}.setText('Seçilen Form : Yok!');
                                            #{PickWindowFormAdd}.setTitle('Ekle');
                                            #{TextFieldListeAd}.setValue('');
                                            #{TextFieldAciklama}.setValue('');
                                            #{ComboBoxSosyal}.setValue('');                                     
                                            #{PickWindowFormAdd}.show();" />
                                    </Listeners>
                                </ext:Button>

                                <ext:ToolbarSeparator/>
                                
                                <ext:Button ID="BtnEdit" runat="server" Enabled="true" Text="Düzelt" Icon="ApplicationEdit">
                                    <Listeners>
                                        <Click Handler="
                                        var v= #{GridPanel1}.getSelectionModel().getSelection();
                                        if (v.length==0) return;

                                        #{PickWindowFormAdd}.setTitle('Düzelt');
                                        #{TextFieldListeId}.setValue(v[0].data.hedef_liste_id);
                                        #{TextFieldListeAd}.setValue(v[0].data.hedef_liste_ad);
                                        #{TextFieldAciklama}.setValue(v[0].data.aciklama);
                                        #{ComboBoxSosyal}.setValue(v[0].data.telefon_mail);                                      
                                        #{PickWindowFormAdd}.show();" />
                                    </Listeners>   
                                </ext:Button>

                                <ext:ToolbarSeparator/>
                                
                                <ext:Button ID="BtnRemove" runat="server" Enabled="true" Text="Sil" Icon="ApplicationDelete">
                                    <Listeners>
                                        <Click Handler="
                                                        var v= #{GridPanel1}.getSelectionModel().getSelection();
                                                        if (v.length==0) return;
                                                        Ext.MessageBox.confirm('Dikkat', 'Silmek istiyor musunuz?\n('+v[0].data.hedef_liste_id + ' ' + v[0].data.hedef_liste_ad + ')', showResult );" Delay="1"/>
                                    </Listeners>
                                </ext:Button>                                

                                <ext:ToolbarSeparator/>
                                
                                <ext:Button ID="Button1" runat="server" Enabled="true" Text="Detay İşlemleri" Icon="ApplicationCascade">
                                    <DirectEvents>
                                        <Click OnEvent="DetayEkraniAc" Before="Ext.MessageBox.show({
	                                                                      msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                                      progressText: 'Bekleyiniz...',
	                                                                      width:300,
	                                                                      wait:true,
	                                                                      waitConfig: {interval:200}
	                                                                    });" Delay="1"/>
                                    </DirectEvents>
                                </ext:Button>
                                
                                <ext:ToolbarSeparator/>

                                <ext:Label ID="lbUser" runat="server" Text="Seçilen Kitle : Yok!"></ext:Label>                                
                            </Items>
                        </ext:Toolbar>
                        
                    </TopBar>
                    
                    <Items>

                        <ext:GridPanel ID="GridPanel1" 
                            runat="server" 
                            Frame="true"
                            Height="600">
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
                                        <ext:Parameter Name="limit" Value="23" Mode="Raw" />
                                    </AutoLoadParams>
                                    <Proxy>
                                        <ext:PageProxy />
                                    </Proxy>
                                    <Model>
                                        <ext:Model ID="Model1" runat="server" IDProperty="master_nos">
                                            <Fields>
                                                <ext:ModelField Name="master_no" />
                                                <ext:ModelField Name="hedef_liste_id" />
                                                <ext:ModelField Name="hedef_liste_ad" />
                                                <ext:ModelField Name="telefon_mail" />
                                                <ext:ModelField Name="aciklama" />
                                            </Fields>
                                        </ext:Model>
                                    </Model>
                                    <Sorters>
                                        <ext:DataSorter Property="hedef_liste_id" Direction="ASC" />
                                    </Sorters>
                                </ext:Store>

                            </Store>
                            <ColumnModel ID="ColumnModel1" runat="server">
                                <Columns>
                                    <ext:Column ID="Id" runat="server" Text="Liste Id" DataIndex="hedef_liste_id" Sortable="true" Flex="1" />
                                    <ext:Column ID="Column3" runat="server" Text="Liste Ad" DataIndex="hedef_liste_ad" Width="130" />
                                    <ext:Column ID="Column4" runat="server" Text="Açıklama" DataIndex="aciklama" Width="230" />
                                    <ext:Column ID="Column1" runat="server" Text="Telefon/Mail" DataIndex="telefon_mail" Width="130" />
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
                                <Select Handler="
                                    var v= #{GridPanel1}.getSelectionModel().getSelection();
                                    if (v.length>0) { 
                                        #{gizli}.setValue(v[0].data.master_no); 
                                        #{lbUser}.setText('Seçilen Kitle : ' + v[0].data.hedef_liste_id + ' ' + v[0].data.hedef_liste_ad);
                                        #{PickWindowDetailForm}.setTitle('Seçilen Kitle : ' + v[0].data.hedef_liste_id + ' ' + v[0].data.hedef_liste_ad);
                                    } else {
                                        #{gizli}.setValue(''); 
                                        #{lbUser}.setText('Seçilen Kitle : Yok!');
                                        #{PickWindowDetailForm}.setTitle('Seçilen Kitle : Yok!');
                                } "/>
                            </Listeners>

                            <BottomBar>
                                <ext:PagingToolbar ID="PagingToolbar1" 
                                    runat="server" 
                                    PageSize="23" 
                                    StoreID="Store1" 
                                    DisplayInfo="true" 
                                    DisplayMsg="Gösterilen {0} - {1} / {2}" 
                                    EmptyMsg="Kayıt yok."
                                />
                            </BottomBar>
                            <Features>
                                <ext:RowBody ID="RowBody1" runat="server" >
                                </ext:RowBody>
                            </Features>                            
                        </ext:GridPanel>

                    </Items>
                </ext:Panel>
            </Items>
        </ext:Viewport>  

    </form>
</body>
</html>
