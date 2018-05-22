<%@ Page Language="C#" %>

<%@ Import Namespace="System.Collections.Generic" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            this.Store1.DataSource = this.Data;
        }
    }

    protected void LoadData(object sender, DirectEventArgs e)
    {
        /*
         FormPanel1.SetValues(new {
            Email = "henry@example.com",
            Title = "Mr",
            FirstName = "Henry",
            LastName = "Example",
            StartDate = new DateTime(2003, 1, 10),
            EndDate = new DateTime(2009, 12,11),
            Phone1 = 555,
            Phone2 = 123,
            Phone3 = 4567,
            Hours = 7,
            Minutes = 15
         });
         */
    }

    private object[] Data
    {
        get
        {
            return new object[]
            {
                new object[] {"3m Co", 71.72, 0.02, 0.03, "9/1 12:00am"},
                new object[] {"Alcoa Inc", 29.01, 0.42, 1.47, "9/1 12:00am"},
                new object[] {"Altria Group Inc", 83.81, 0.28, 0.34, "9/1 12:00am"},
                new object[] {"American Express Company", 52.55, 0.01, 0.02, "9/1 12:00am"},
                new object[] {"American International Group, Inc.", 64.13, 0.31, 0.49, "9/1 12:00am"},
                new object[] {"AT&T Inc.", 31.61, -0.48, -1.54, "9/1 12:00am"},
                new object[] {"Boeing Co.", 75.43, 0.53, 0.71, "9/1 12:00am"},
                new object[] {"Caterpillar Inc.", 67.27, 0.92, 1.39, "9/1 12:00am"},
                new object[] {"Citigroup, Inc.", 49.37, 0.02, 0.04, "9/1 12:00am"},
                new object[] {"E.I. du Pont de Nemours and Company", 40.48, 0.51, 1.28, "9/1 12:00am"},
                new object[] {"Exxon Mobil Corp", 68.1, -0.43, -0.64, "9/1 12:00am"},
                new object[] {"General Electric Company", 34.14, -0.08, -0.23, "9/1 12:00am"},
                new object[] {"General Motors Corporation", 30.27, 1.09, 3.74, "9/1 12:00am"},
                new object[] {"Hewlett-Packard Co.", 36.53, -0.03, -0.08, "9/1 12:00am"},
                new object[] {"Honeywell Intl Inc", 38.77, 0.05, 0.13, "9/1 12:00am"},
                new object[] {"Intel Corporation", 19.88, 0.31, 1.58, "9/1 12:00am"},
                new object[] {"International Business Machines", 81.41, 0.44, 0.54, "9/1 12:00am"},
                new object[] {"Johnson & Johnson", 64.72, 0.06, 0.09, "9/1 12:00am"},
                new object[] {"JP Morgan & Chase & Co", 45.73, 0.07, 0.15, "9/1 12:00am"},
                new object[] {"McDonald\"s Corporation", 36.76, 0.86, 2.40, "9/1 12:00am"},
                new object[] {"Merck & Co., Inc.", 40.96, 0.41, 1.01, "9/1 12:00am"},
                new object[] {"Microsoft Corporation", 25.84, 0.14, 0.54, "9/1 12:00am"},
                new object[] {"Pfizer Inc", 27.96, 0.4, 1.45, "9/1 12:00am"},
                new object[] {"The Coca-Cola Company", 45.07, 0.26, 0.58, "9/1 12:00am"},
                new object[] {"The Home Depot, Inc.", 34.64, 0.35, 1.02, "9/1 12:00am"},
                new object[] {"The Procter & Gamble Company", 61.91, 0.01, 0.02, "9/1 12:00am"},
                new object[] {"United Technologies Corporation", 63.26, 0.55, 0.88, "9/1 12:00am"},
                new object[] {"Verizon Communications", 35.57, 0.39, 1.11, "9/1 12:00am"},
                new object[] {"Wal-Mart Stores, Inc.", 45.45, 0.73, 1.63, "9/1 12:00am"}
            };
        }
    }

    protected void SaveData(object sender, DirectEventArgs e)
    {
        /*
        Dictionary<string, string> values = JSON.Deserialize<Dictionary<string, string>>(e.ExtraParams["values"]);
        StringBuilder sb = new StringBuilder();

        foreach (KeyValuePair<string, string> value in values)
        {
            sb.AppendFormat("{0} = {1}<br />", value.Key, value.Value);
        }

        X.Msg.Alert("Values", sb.ToString()).Show();
        */
    }


</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Crm Cagri Bilgileri</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />
    <style>
        #liste_kod .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #cari_kod .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #yetkili_kisi .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #unvan .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #ilce_ad .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #sehir_ad .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #ulke_kod .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #urun_hizmet .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #cagri_cevap .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #onem_derece .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #ckategori_kod1 .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #ckategori_kod2 .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #ckategori_kod3 .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #ckategori_kod4 .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #ckategori_kod5 .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #cagri_nedeni .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #cagri_konusu .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #aciklama1 {
            margin-top: 10px;
        }

        #aciklama2 {
            margin-top: 10px;
            margin-bottom: 10px;
        }
        .x-grid-row-over .x-grid-cell-inner {
            font-weight : bold;
        }
    </style>
    <script>
        var template = '<span style="color:{0};">{1}</span>';

        var change = function (value) {
            return Ext.String.format(template, (value > 0) ? "green" : "red", value);
        };

        var pctChange = function (value) {
            return Ext.String.format(template, (value > 0) ? "green" : "red", value + "%");
        };
    </script>
</head>
<body>
    <ext:ResourceManager runat="server" />

    <ext:FormPanel
        runat="server"
        Height="1200"
        Width="1200"
        BodyPadding="5"
        MonitorResize="true">
        <Items>
            <ext:FieldContainer
                runat="server"
                FieldLabel="Çağrı Trh/Tipi"
                AnchorHorizontal="100%"
                Layout="HBoxLayout">
                <Items>
                    <ext:DateField ID="belge_tarih" Editable="false" runat="server" Width="150" MarginSpec="0 3 0 0" />
                    <ext:ComboBox ID="cagri_tipi"
                        runat="server"
                        Width="150"
                        Editable="false">
                        <Items>
                            <ext:ListItem Text="Gelen Çağrı" Value="Gelen" />
                            <ext:ListItem Text="Giden Çağrı" Value="Giden" />
                        </Items>
                        <SelectedItems>
                            <ext:ListItem Value="Gelen" />
                        </SelectedItems>
                    </ext:ComboBox>
                    <ext:DisplayField runat="server" Flex="1" Html="&nbsp;" />
                    <ext:DateField ID="mulk_olma_tarih" FieldLabel="E-Fatura Mük.Olma Tarihi" Editable="false" ReadOnly="True" runat="server" Width="250" />
                </Items>
            </ext:FieldContainer>

            <ext:FieldContainer
                runat="server"
                AnchorHorizontal="100%"
                Layout="HBoxLayout">
                <Items>

                    <ext:TextField
                        runat="server"
                        Width="255"
                        ID="cari_id"
                        FieldLabel="Cari Id"
                        MarginSpec="0 3 0 0"
                        AllowBlank="true" />
                    
                    <ext:DisplayField runat="server" Width="135" Html="&nbsp;" />
                    <ext:TextField runat="server" Width="225" ID="liste_kod" FieldLabel="Liste Kodu" AllowBlank="true" />
                    
                    <ext:DisplayField runat="server" Width="50" Html="&nbsp;" />
                    <ext:DateField ID="ilk_randevu_tarih" FieldLabel="İlk Randevu Tarih" Editable="false" runat="server" Width="250"/>
                    
                    <ext:DisplayField runat="server" Width="20" Html="&nbsp;" />
                    <ext:DateField ID="son_gorusme_tarih" FieldLabel="Son Görüşme Tarihi" Editable="false" runat="server" Width="250" />

                </Items>
            </ext:FieldContainer>
            
            <ext:FieldContainer
                runat="server"
                AnchorHorizontal="100%"
                Layout="HBoxLayout">
                <Items>

                    <ext:TextField runat="server" Width="255" ID="cari_kod" FieldLabel="Müşteri Kodu" MarginSpec="0 3 0 0" AllowBlank="true" />
                    
                    <ext:DisplayField runat="server" Width="10" Html="&nbsp;" />
                    <ext:TextField runat="server" Width="425" ID="cari_ad" ReadOnly="True" AllowBlank="true" />
                    
                    <ext:DisplayField runat="server" Width="10" Html="&nbsp;" />
                    <ext:Button runat="server" Text="Google'da Ara" />

                </Items>
            </ext:FieldContainer>
            
            <ext:FieldContainer
                runat="server"
                AnchorHorizontal="100%"
                Layout="HBoxLayout">
                <Items>
                    <ext:TextField runat="server" Width="355" ID="yetkili_kisi" FieldLabel="Görüşülen Kişi" MarginSpec="0 3 0 0" AllowBlank="true" />
                    <ext:ComboBox ID="cinsiyet"
                                  runat="server"
                                  Width="80"
                                  Editable="false">
                        <Items>
                            <ext:ListItem Text="Bay" Value="Bay" />
                            <ext:ListItem Text="Bayan" Value="Bayan" />
                        </Items>
                        <SelectedItems>
                            <ext:ListItem Value="Bay" />
                        </SelectedItems>
                    </ext:ComboBox>
                    <ext:DisplayField runat="server" Flex="1" Html="&nbsp;" />
                    <ext:TextField runat="server" Width="700" ID="adres1" FieldLabel="Adres-1" MarginSpec="0 3 0 0" AllowBlank="true" />
                </Items>
            </ext:FieldContainer>

            <ext:FieldContainer
                runat="server"
                AnchorHorizontal="100%"
                Layout="HBoxLayout">
                <Items>
                    <ext:TextField runat="server" Width="355" ID="unvan" FieldLabel="Ünvan" MarginSpec="0 3 0 0" AllowBlank="true" />
                    <ext:DisplayField runat="server" Flex="1" Html="&nbsp;" />
                    <ext:TextField runat="server" Width="700" ID="adres2" FieldLabel="Adres-2" MarginSpec="0 3 0 0" AllowBlank="true" />
                </Items>
            </ext:FieldContainer>

            <ext:FieldContainer
                runat="server"
                AnchorHorizontal="100%"
                Layout="HBoxLayout">
                <Items>
                    <ext:TextField runat="server" Width="278" ID="telefon" FieldLabel="İş Tel./Cep Tel" MarginSpec="0 3 0 0" AllowBlank="true" />
                    <ext:TextField runat="server" Width="172" ID="ceptel" MarginSpec="0 3 0 0" AllowBlank="true" />
                    <ext:DisplayField runat="server" Flex="1" Html="&nbsp;" />
                    <ext:TextField runat="server" Width="700" ID="adres3" FieldLabel="Adres-3" MarginSpec="0 3 0 0" AllowBlank="true" />
                </Items>
            </ext:FieldContainer>
            
            <ext:FieldContainer
                runat="server"
                AnchorHorizontal="100%"
                Layout="HBoxLayout">
                <Items>
                    <ext:TextField runat="server" Width="304" ID="email" FieldLabel="EMail/Ür-Hiz." MarginSpec="0 3 0 0" AllowBlank="true" />
                    <ext:TextField runat="server" Width="146" ID="urun_hizmet" MarginSpec="0 3 0 0" AllowBlank="true" />
                    <ext:DisplayField runat="server" Flex="1" Html="&nbsp;" />
                    <ext:TextField runat="server" FieldLabel="İlçe/İl/Ülke" Width="294" ID="ilce_ad" MarginSpec="0 3 0 0" AllowBlank="true" />
                    <ext:TextField runat="server" Width="200" ID="sehir_ad" MarginSpec="0 3 0 0" AllowBlank="true" />
                    <ext:TextField runat="server" Width="200" ID="ulke_kod" MarginSpec="0 3 0 0" AllowBlank="true" />
                </Items>
            </ext:FieldContainer>
            
            <ext:Container runat="server" Layout="HBoxLayout" MarginSpec="0 0 10">
                <Items>
                    
                    <ext:Panel runat="server" Flex="1" CollapseDirection="Left">
                        <Items>
                            
                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="cagri_cevap" FieldLabel="Çağrı Cevap" MarginSpec="0 3 0 0" AllowBlank="true" />
                                    <ext:TextField runat="server" Width="146" ID="cagri_cevap2" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>
                    
                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="onem_derece" FieldLabel="Önem Derece" MarginSpec="0 3 0 0" AllowBlank="true" />
                                    <ext:TextField runat="server" Width="146" ID="onem_derece2" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>
                            
                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod1" FieldLabel="Cari Kat.Kod-1" MarginSpec="0 3 0 0" AllowBlank="true" />
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad1" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>

                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod2" FieldLabel="Cari Kat.Kod-2" MarginSpec="0 3 0 0" AllowBlank="true" />
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad2" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>

                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod3" FieldLabel="Cari Kat.Kod-3" MarginSpec="0 3 0 0" AllowBlank="true" />
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad3" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>

                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod4" FieldLabel="Cari Kat.Kod-4" MarginSpec="0 3 0 0" AllowBlank="true" />
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad4" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>

                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod5" FieldLabel="Cari Kat.Kod-5" MarginSpec="0 3 0 0" AllowBlank="true" />
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad5" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>

                        </Items>
                    </ext:Panel>

                    <ext:Panel runat="server" Flex="1" CollapseDirection="Right" >
                        <Items>
                            <ext:TextArea runat="server" ID="aciklama1" Width="590" Height="265" BoxLabel="CheckBox" Note="Açıklama" />
                        </Items>
                    </ext:Panel>

                </Items>
            </ext:Container>

	    <ext:Container runat="server" Layout="HBoxLayout" MarginSpec="0 0 10">
            <Items>
			    <ext:Panel runat="server" Width="310" CollapseDirection="Left">
				    <Items>
                        <ext:GridPanel
                            ID="GridPanel1"
                            runat="server"
                            Width="300"
                            Height="400">
                            <Store>
                                <ext:Store ID="Store1" runat="server">
                                    <Model>
                                        <ext:Model runat="server">
                                            <Fields>
                                                <ext:ModelField Name="company" />
                                                <ext:ModelField Name="price" Type="Float" />
                                                <ext:ModelField Name="change" Type="Float" />
                                                <ext:ModelField Name="pctChange" Type="Float" />
                                                <ext:ModelField Name="lastChange" Type="Date" DateFormat="M/d hh:mmtt" />
                                            </Fields>
                                        </ext:Model>
                                    </Model>
                                </ext:Store>
                            </Store>
                            <ColumnModel>
                                <Columns>
                                    <ext:Column runat="server" Text="Company" DataIndex="company" Width="290"/>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel runat="server" />
                            </SelectionModel>
                            <BottomBar>
                                <ext:Toolbar runat="server">
                                    <Items>
                                        <ext:Button runat="server" Text="Kategori Ekle" Icon="Add" Handler="this.up('grid').print();" />
                                        <ext:Button runat="server" Text="Kategori Sil" Icon="Delete" Handler="this.up('grid').print();" />
                                    </Items>
                                </ext:Toolbar>
                            </BottomBar>
                        </ext:GridPanel>
				    </Items>
                </ext:Panel>
                
			    <ext:Panel runat="server" Width="300" CollapseDirection="Left">
                    <Items>
                        <ext:GridPanel
                            ID="GridPanel2"
                            runat="server"
                            Width="290"
                            Height="400">
                            <Store>
                                <ext:Store ID="Store2" runat="server">
                                    <Model>
                                        <ext:Model runat="server">
                                            <Fields>
                                                <ext:ModelField Name="company" />
                                                <ext:ModelField Name="price" Type="Float" />
                                                <ext:ModelField Name="change" Type="Float" />
                                                <ext:ModelField Name="pctChange" Type="Float" />
                                                <ext:ModelField Name="lastChange" Type="Date" DateFormat="M/d hh:mmtt" />
                                            </Fields>
                                        </ext:Model>
                                    </Model>
                                </ext:Store>
                            </Store>
                            <ColumnModel>
                                <Columns>
                                    <ext:Column runat="server" Text="Bilgi" DataIndex="company" Width="400"/>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel runat="server" />
                            </SelectionModel>
                        </ext:GridPanel>
                    </Items>
			    </ext:Panel>
            
                <ext:Panel runat="server" Flex="1" CollapseDirection="Right">
                    <Items>
                        
                        <ext:FieldContainer
                            runat="server"
                            AnchorHorizontal="100%"
                            Layout="HBoxLayout">
                            <Items>
                                <ext:TextField runat="server" Width="304" ID="cagri_nedeni" FieldLabel="Çağri Nedeni" MarginSpec="0 3 0 0" AllowBlank="true" />
                                <ext:TextField runat="server" Width="264" ID="cagri_nedeni2" MarginSpec="0 3 0 0" AllowBlank="true" />
                            </Items>
                        </ext:FieldContainer>

                        <ext:FieldContainer
                            runat="server"
                            AnchorHorizontal="100%"
                            Layout="HBoxLayout">
                            <Items>
                                <ext:TextField runat="server" Width="304" ID="cagri_konusu" FieldLabel="Çağri Konusu" MarginSpec="0 3 0 0" AllowBlank="true" />
                                <ext:TextField runat="server" Width="266" ID="cagri_konusu2" MarginSpec="0 3 0 0" AllowBlank="true" />
                            </Items>
                        </ext:FieldContainer>

                        <ext:FieldContainer
                            runat="server"
                            AnchorHorizontal="100%"
                            Layout="HBoxLayout">
                            <Items>
                                <ext:TextField runat="server" Width="304" ID="kullanici" FieldLabel="Kullanıcı/Ref.No" MarginSpec="0 3 0 0" AllowBlank="true" />
                                <ext:TextField runat="server" Width="266" ID="refno" MarginSpec="0 3 0 0" AllowBlank="true" />
                            </Items>
                        </ext:FieldContainer>
                        
                        <ext:FieldContainer
                            runat="server"
                            AnchorHorizontal="100%"
                            Layout="HBoxLayout">
                            <Items>
                                <ext:TextArea runat="server" ID="aciklama2" Width="574" Height="255" BoxLabel="CheckBox" Note="Açıklama 2" />
                            </Items>
                        </ext:FieldContainer>

                    </Items>
                </ext:Panel>
            </Items>
	   </ext:Container>

        </Items>
    </ext:FormPanel>

    
</body>
</html>
