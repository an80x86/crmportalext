<%@ Page Language="C#" %>

<%@ Import Namespace="System.Collections.Generic" %>

<script runat="server">
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
        /*
        .dot-label {
            font-weight : bold;
            font-size   : 20px;
        }

        .note .x-form-item {
            margin-bottom : 0px;
        }

        .note .x-form-display-field {
            color : gray;
            padding-top   : 0px;
            padding-left  : 105px;
            margin-bottom : 5px;
        }
        */
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

        #aciklama1 {
            margin-top: 10px;
        }

    </style>
</head>
<body>
    <ext:ResourceManager runat="server" />

    <ext:FormPanel
        runat="server"
        Height="800"
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

        </Items>
    </ext:FormPanel>

    
</body>
</html>