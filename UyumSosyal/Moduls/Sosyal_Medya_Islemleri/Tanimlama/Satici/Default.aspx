<%@ Page Language="C#" %>

<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="UyumSosyal" %>
<%@ Import Namespace="UyumSosyal.WebReference" %>
<%@ Import Namespace="Newtonsoft.Json.Linq" %>

<script runat="server">
    protected void Kaydet(object sender, DirectEventArgs e)
    {
        var deger = e.ExtraParams[0];
        dynamic d = JObject.Parse(deger.Value.ToString());
        try
        {
            var sonuc = Helper.GetWebService().SaticiKaydet(new Satici()
            {
                saticiId = int.Parse(d.psaticiId.Value.ToString()), 
                satici_kod = d.psatici_kod,    
                satici_ad = d.psatici_ad,
                bolge_kod = d.pbolge_kod, 
                okod1 = d.pokod1, 
                okod2 = d.pokod2,
                aciklama = d.paciklama,        
                adres1 = d.padres1,        
                adres2 = d.padres2,        
                adres3 = d.padres3,        
                tel1 = d.ptel1,        
                tel2 = d.ptel2,        
                fax = d.pfax,        
                email = d.pemail,        
                aktif = d.paktif,        
                yuzde = (decimal) double.Parse(d.pyuzde.Value.ToString())
            });
            X.MessageBox.Hide();

            if (!sonuc.Result)
            {
                X.MessageBox.Hide();
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
                return;
            }

            Store1.DataSource = Helper.GetWebService().SaticiListesi("", "").Value;
            Store1.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Hide();
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }

        PickWindowEkle.Hide();
    }

    [DirectMethod]
    public void Sil(string id)
    {
        try
        {
            var sonuc = Helper.GetWebService().SaticiSil(id.ToInt());
            X.MessageBox.Hide();
            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
            }

            Store1.DataSource = Helper.GetWebService().SaticiListesi("", "").Value;
            Store1.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            this.Store1.DataSource = Helper.GetWebService().SaticiListesi("", "").Value;
            this.StoreIlBolge.DataSource = Helper.GetWebService().BolgeListesi("").Value;
        }
    }

</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Form Kategori</title>

    <link href="/resources/css/examples.css" rel="stylesheet" />
    <style>
        #pbolge_kod .x-form-text {
            background-image: none;
            background-color: yellow;
        }
    </style>

    <script>

    </script>
</head>
<body>
    <ext:ResourceManager runat="server" DirectMethodNamespace="CompanyX" />

    <ext:Action
        ID="RemoveAction"
        runat="server"
        Icon="Delete"
        Text="Sil"
        Disabled="true"
        Handler="var rec = #{GridPanel1}.getSelectionModel().getSelection()[0]; 
                if (rec) { 
                    Ext.MessageBox.show({
                            title: 'Dikkat',
                            msg: 'Silmek ister misiniz? ('+ rec.get('satici_kod') +')',
                            buttons: Ext.MessageBox.OKCANCEL,
                            icon: Ext.MessageBox.WARNING,
                            fn: function(btn){
                                if(btn === 'ok'){
                                    Ext.MessageBox.show({
                                                         msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                     waitConfig: {interval:200}
	                                                    });                                            
                        
                                    CompanyX.Sil(rec.get('saticiId'));
                                }
                            }
                        });

                }" />

    <ext:Action
        ID="EditAction"
        runat="server"
        Icon="CartEdit"
        Text="Düzelt"
        Disabled="true"
        Handler="var rec = #{GridPanel1}.getSelectionModel().getSelection()[0]; 
                if (rec) { 
                    #{psaticiId}.setValue(rec.get('saticiId'));
                    #{psatici_kod}.setValue(rec.get('satici_kod'));
                    #{psatici_ad}.setValue(rec.get('satici_ad'));
                    #{pbolge_kod}.setValue(rec.get('bolge_kod'));
                    #{paciklama}.setValue(rec.get('aciklama'));
                    #{padres1}.setValue(rec.get('adres1'));
                    #{padres2}.setValue(rec.get('adres2'));
                    #{padres3}.setValue(rec.get('adres3'));
                    #{ptel1}.setValue(rec.get('tel1'));
                    #{ptel2}.setValue(rec.get('tel2'));
                    #{pfax}.setValue(rec.get('fax'));
                    #{pemail}.setValue(rec.get('email'));
                    #{paktif}.setValue(rec.get('aktif'));
                    #{pyuzde}.setValue(rec.get('yuzde'));
                    #{PickWindowEkle}.show();
                }
        " />

    <ext:Action
        ID="BuyAction"
        runat="server"
        Icon="CarAdd"
        Text="Ekle"
        Handler="
            #{psaticiId}.setValue(0);
            #{psatici_kod}.setValue('');
            #{psatici_ad}.setValue('');
            #{pbolge_kod}.setValue('');
            #{paciklama}.setValue('');
            #{padres1}.setValue('');
            #{padres2}.setValue('');
            #{padres3}.setValue('');
            #{ptel1}.setValue('');
            #{ptel2}.setValue('');
            #{pemail}.setValue('');
            #{paktif}.setValue('Aktif');
            #{pyuzde}.setValue('0');
            #{PickWindowEkle}.show();
        " />

    <ext:Menu ID="ContextMenu" runat="server">
        <Items>
            <ext:ActionRef runat="server" Action="#{RemoveAction}" />
            <ext:ActionRef runat="server" Action="#{EditAction}" />
            <ext:ActionRef runat="server" Action="#{BuyAction}" />
        </Items>
    </ext:Menu>

    <ext:GridPanel
        ID="GridPanel1"
        runat="server"
        ColumnLines="true"
        Title="Satici"
        Width="600"
        Height="650">
        <Store>
            <ext:Store ID="Store1" runat="server">
                <Model>
                    <ext:Model runat="server">
                        <Fields>
                            <ext:ModelField Name="satici_kod" />
                            <ext:ModelField Name="satici_ad" />
                            <ext:ModelField Name="bolge_kod" />
                            <ext:ModelField Name="aciklama" />
                            <ext:ModelField Name="adres1" />
                            <ext:ModelField Name="adres2" />
                            <ext:ModelField Name="adres3" />
                            <ext:ModelField Name="tel1" />
                            <ext:ModelField Name="tel2" />
                            <ext:ModelField Name="fax" />
                            <ext:ModelField Name="email" />
                            <ext:ModelField Name="aktif" />
                            <ext:ModelField Name="yuzde" Type="Float" />
                            <ext:ModelField Name="saticiId" Type="Int" />
                        </Fields>
                    </ext:Model>
                </Model>
            </ext:Store>
        </Store>
        <ColumnModel>
            <Columns>
                <ext:Column runat="server" Text="Kod" DataIndex="satici_kod" Width="130" />
                <ext:Column runat="server" Text="Ad" DataIndex="satici_ad" Flex="1">
                </ext:Column>
            </Columns>
        </ColumnModel>
        <Plugins>
            <ext:FilterHeader runat="server" />
        </Plugins>
        <SelectionModel>
            <ext:RowSelectionModel runat="server">
                <Listeners>
                    <SelectionChange Handler="if (selected.length) { #{EditAction}.enable(); #{RemoveAction}.enable(); } else { #{EditAction}.disable(); #{RemoveAction}.disable(); }" />
                </Listeners>
            </ext:RowSelectionModel>
        </SelectionModel>
        <DockedItems>
            <ext:Toolbar runat="server">
                <Items>
                    <ext:ActionRef runat="server" Action="#{EditAction}" />
                    <ext:ActionRef runat="server" Action="#{RemoveAction}" />
                    <ext:ActionRef runat="server" Action="#{BuyAction}" />
                </Items>
            </ext:Toolbar>
        </DockedItems>
    </ext:GridPanel>

    <ext:Window ID="PickWindowEkle" runat="server" Width="350" Height="670" AutoHeight="true" Title="Ekle/Düzelt"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:FormPanel
                ID="PickEkle"
                runat="server"
                Layout="Fit"
                AutoScroll="true">
                    <Items>
                        <ext:FieldSet runat="server" DefaultWidth="310" Padding="5">
                    <Items>
                        <ext:TextField
                            Width="290"
                            runat="server"
                            InputType="Number"
                            AllowBlank="False"
                            ID="psaticiId"
                            Hidden="true" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            InputType="Text"
                            AllowBlank="False"
                            FieldLabel="Kod"
                            ID="psatici_kod"
                            EmptyText="Kod" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="false"
                            FieldLabel="Ad"
                            ID="psatici_ad"
                            EmptyText="Ad" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="true"
                            FieldLabel="Bölge Kodu"
                            ID="pbolge_kod"
                            EmptyText="Bölge Kodu" ReadOnly="True" RightButtonsShowMode="MouseOver">
                                <RightButtons>
                                    <ext:Button runat="server" Icon="Add">
                                        <Listeners>
                                            <Click Handler="#{PickWindowIlBolge}.show();" />
                                        </Listeners>
                                    </ext:Button>
                            </RightButtons>
                        </ext:TextField>

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="true"
                            FieldLabel="Açıklama"
                            ID="paciklama"
                            EmptyText="Açıklama" />
                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="true"
                            FieldLabel="Adres 1"
                            ID="padres1"
                            EmptyText="Adres 1" />
                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="true"
                            FieldLabel="Adres 2"
                            ID="padres2"
                            EmptyText="Adres 2" />
                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="true"
                            FieldLabel="Adres 3"
                            ID="padres3"
                            EmptyText="Adres 3" />
                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="true"
                            FieldLabel="Telefon 1"
                            ID="ptel1"
                            EmptyText="Telefon 1" />
                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="true"
                            FieldLabel="Telefon 2"
                            ID="ptel2"
                            EmptyText="Telefon 2" />
                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="true"
                            FieldLabel="Faks"
                            ID="pfax"
                            EmptyText="Faks" />
                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="true"
                            FieldLabel="E-Posta"
                            ID="pemail"
                            EmptyText="E-Posta" />
                        <ext:ComboBox ID="paktif"
                                      runat="server"
                                      Width="200" FieldLabel="K.Durumu"
                                      Editable="false">
                            <Items>
                                <ext:ListItem Text="Aktif" Value="Aktif" />
                                <ext:ListItem Text="Pasif" Value="Pasif" />
                            </Items>
                            <SelectedItems>
                                <ext:ListItem Value="Aktif" />
                            </SelectedItems>
                        </ext:ComboBox>
                        <ext:NumberField
                            ID="pyuzde"
                            runat="server"
                            FieldLabel="Yüzde"
                            MinValue="0"
                            MaxValue="100"
                            AllowDecimals="true"
                            DecimalPrecision="1"
                            Step="0.1"
                            />
                    </Items>
                </ext:FieldSet>
                    </Items>
                    <Buttons>
                        <ext:Button runat="server" Text="Tamam" Icon="Accept" Disabled="True" FormBind="True"  Handler="#{PickWindowEkle}.show();">
                            <DirectEvents>
                                <Click OnEvent="Kaydet" Before="Ext.MessageBox.show({
	                                                                      msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                                      waitConfig: {interval:200}
	                                                                    });" Delay="1">
                                    <ExtraParams>
                                        <ext:Parameter Name="Values" Value="#{PickEkle}.getValues(false)" Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowEkle}.hide();" />
                    </Buttons>
                </ext:FormPanel>
        </Items>
    </ext:Window>

    <ext:Window ID="PickWindowIlBolge" runat="server" Width="400" Height="440" AutoHeight="true" Title="Bölge"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:GridPanel
                ID="GridPanelIlBolge"
                runat="server" Height="310">
                <Store>
                    <ext:Store ID="StoreIlBolge" runat="server">
                        <Model>
                            <ext:Model runat="server">
                                <Fields>
                                    <ext:ModelField Name="bolge_kod" />
                                    <ext:ModelField Name="bolge_ad" />
                                    <ext:ModelField Name="bolgeId" Type="Int" />
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>
                        <ext:Column runat="server" Text="Bölge" DataIndex="bolge_ad" Width="230"/>
                    </Columns>
                </ColumnModel>
                <Plugins>
                    <ext:FilterHeader runat="server" />
                </Plugins>
                <SelectionModel>
                    <ext:RowSelectionModel runat="server" />
                </SelectionModel>
            </ext:GridPanel> 
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                    var v= #{GridPanelIlBolge}.getSelectionModel().getSelection();
                    if (v.length==0) return;
                    #{pbolge_kod}.setValue(v[0].data.bolge_kod);
                    #{PickWindowIlBolge}.hide();
                " />
            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowIlBolge}.hide();" />
        </Buttons>
    </ext:Window>

</body>
</html>