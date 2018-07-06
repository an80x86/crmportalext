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
            var sonuc = Helper.GetWebService().SektorKaydet(new Sektor()
            {
                sektorId = int.Parse(d.psektorId.Value.ToString()),   
                sektor_kod = d.psektor_kod,      
                sektor_ad = d.psektor_ad
            });
            X.MessageBox.Hide();

            if (!sonuc.Result)
            {
                X.MessageBox.Hide();
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
                return;
            }

            Store1.DataSource = Helper.GetWebService().GenelSektorListesi("").Value;
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
            var sonuc = Helper.GetWebService().SektorSil(id.ToInt());
            X.MessageBox.Hide();
            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
            }

            Store1.DataSource = Helper.GetWebService().GenelSektorListesi("").Value;
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
            this.Store1.DataSource = Helper.GetWebService().GenelSektorListesi("").Value;
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
                            msg: 'Silmek ister misiniz? ('+ rec.get('sektor_kod') +')',
                            buttons: Ext.MessageBox.OKCANCEL,
                            icon: Ext.MessageBox.WARNING,
                            fn: function(btn){
                                if(btn === 'ok'){
                                    Ext.MessageBox.show({
                                                         msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                     waitConfig: {interval:200}
	                                                    });                                            
                        
                                    CompanyX.Sil(rec.get('sektorId'));
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
                    #{psektorId}.setValue(rec.get('sektorId'));
                    #{psektor_kod}.setValue(rec.get('sektor_kod'));
                    #{psektor_ad}.setValue(rec.get('sektor_ad'));
                    #{PickWindowEkle}.show();
                }
        " />

    <ext:Action
        ID="BuyAction"
        runat="server"
        Icon="CarAdd"
        Text="Ekle"
        Handler="
            #{psektorId}.setValue(0);
            #{psektor_kod}.setValue('');
            #{psektor_ad}.setValue('');
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
        Title="Sektör"
        Width="600"
        Height="650">
        <Store>
            <ext:Store ID="Store1" runat="server">
                <Model>
                    <ext:Model runat="server">
                        <Fields>
                            <ext:ModelField Name="sektor_kod" />
                            <ext:ModelField Name="sektor_ad" />
                            <ext:ModelField Name="sektorId" Type="Int" />
                        </Fields>
                    </ext:Model>
                </Model>
            </ext:Store>
        </Store>
        <ColumnModel>
            <Columns>
                <ext:Column runat="server" Text="Kod" DataIndex="sektor_kod" Width="130" />
                <ext:Column runat="server" Text="Ad" DataIndex="sektor_ad" Flex="1">
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

    <ext:Window ID="PickWindowEkle" runat="server" Width="350" Height="200" AutoHeight="true" Title="Ekle/Düzelt"
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
                                    ID="psektorId"
                                    Hidden="true" />

                                <ext:TextField
                                    Width="290"
                                    runat="server"
                                    InputType="Text"
                                    AllowBlank="False"
                                    FieldLabel="Kod"
                                    ID="psektor_kod"
                                    EmptyText="Kod" />

                                <ext:TextField
                                    Width="290"
                                    runat="server"
                                    AllowBlank="false"
                                    FieldLabel="Ad"
                                    ID="psektor_ad"
                                    EmptyText="Ad" />
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

</body>
</html>