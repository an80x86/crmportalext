<%@ Page Language="C#" %>

<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="UyumSosyal" %>
<%@ Import Namespace="UyumSosyal.WebReference" %>
<%@ Import Namespace="Newtonsoft.Json.Linq" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            this.Store1.DataSource = this.Data;

            ulke_kod.SetText("TÜRKİYE");

            HttpRuntime.Cache["Ulke"] = (Ulke[]) HttpRuntime.Cache["Ulke"] == null ? Helper.GetWebService().UlkeListesi("").Value : (Ulke[]) HttpRuntime.Cache["Ulke"];
            HttpRuntime.Cache["Il"] = (Sehir[]) HttpRuntime.Cache["Il"] == null ? Helper.GetWebService().GenelSehirListesi("").Value : (Sehir[]) HttpRuntime.Cache["Il"];
            HttpRuntime.Cache["Ilce"] = (Ilce[]) HttpRuntime.Cache["Ilce"] == null ? Helper.GetWebService().GenelIlceListesi("").Value : (Ilce[]) HttpRuntime.Cache["Ilce"];

            HttpRuntime.Cache["CariKategori"] = (CariKategori[]) HttpRuntime.Cache["CariKategori"] == null ? Helper.GetWebService().GetCKategoriListesi("").Value.CariKategori : (CariKategori[]) HttpRuntime.Cache["CariKategori"];
            HttpRuntime.Cache["Unvan"] = (Unvan[]) HttpRuntime.Cache["Unvan"] == null ? Helper.GetWebService().UnvanListesi2("", "").Value : (Unvan[]) HttpRuntime.Cache["Unvan"];

            StoreUlke.DataSource = HttpRuntime.Cache["Ulke"];
            StoreIl.DataSource = HttpRuntime.Cache["Il"];
            StoreIlce.DataSource = HttpRuntime.Cache["Ilce"];
            StoreCariKategori.DataSource = HttpRuntime.Cache["CariKategori"];
            StoreUnvan.DataSource = HttpRuntime.Cache["Unvan"];
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

    protected void IlKaydet(object sender, DirectEventArgs e)
    {
        var deger = e.ExtraParams[0];
        dynamic d = JObject.Parse(deger.Value.ToString());
        try
        {
            var sonuc = Helper.GetWebService().SehirKaydet(new Sehir()
            {
                bolge_kod = d.pil_bolge_kod.Value,
                plaka_kod = d.pil_plaka_kod.Value,
                sehir_ad = d.pil_sehir_kod.Value,
                sehirId = int.Parse(d.pil_sehir_id.Value),
                telefon_kod = d.pil_telefon_kod.Value,
                ulke_kod = d.pil_ulke_kod.Value
            });
            X.MessageBox.Hide();

            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
                return;
            }

            HttpRuntime.Cache["Il"] = Helper.GetWebService().GenelSehirListesi("").Value;
            StoreIl.DataSource = HttpRuntime.Cache["Il"];
            StoreIl.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }

        PickWindowIlEkle.Hide();
    }

    [DirectMethod]
    public void SehirSil(string id)
    {
        try
        {
            var sonuc = Helper.GetWebService().SehirSil(id.ToInt());
            X.MessageBox.Hide();
            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
            }

            HttpRuntime.Cache["Il"] = Helper.GetWebService().GenelSehirListesi("").Value;
            StoreIl.DataSource = HttpRuntime.Cache["Il"];
            StoreIl.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }
    }

</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Crm Cagri Bilgileri</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />
    <style>
         
        #pil_ulke_kod .x-form-text {
            background-image: none;
            background-color: red;
        }

        #pil_bolge_kod .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #cari_kod .x-form-text {
            background-image: none;
            background-color: yellow;
        }
        
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
        var kodSira = 1;
        var template = '<span style="color:{0};">{1}</span>';

        var change = function (value) {
            return Ext.String.format(template, (value > 0) ? "green" : "red", value);
        };

        var pctChange = function (value) {
            return Ext.String.format(template, (value > 0) ? "green" : "red", value + "%");
        };

        Ext.net.FilterHeader.behaviour.addBehaviour("string", {
            name: "any",

            is: function (value) {
                return Ext.net.StringUtils.startsWith(value, "any ");
            },

            getValue: function (value) {
                var values = Ext.net.FilterHeader.behaviour.getStrValue(value).substring(4).split(" "),
                    tmp = [];

                Ext.each(values, function (v) {
                    v = v.trim();
                    if (!Ext.isEmpty(v)) {
                        tmp.push(v);
                    }
                });

                values = tmp;

                return { value: values, valid: values.length > 0 };
            },

            match: function (recordValue, matchValue) {
                for (var i = 0; i < matchValue.length; i++) {
                    if (recordValue === matchValue[i]) {
                        return true;
                    }
                }

                return false;
            },

            isValid: function (value) {
                return this.getValue(value, field).valid;
            },

            serialize: function (value) {
                return {
                    type: "string",
                    op: "any",
                    value: value
                };
            }
        });
    </script>
</head>
<body>
    <ext:ResourceManager runat="server" DirectMethodNamespace="CompanyX" />

    <ext:FormPanel
        runat="server"
        ID="FormPanel1"
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
                    <ext:DateField ID="mulk_olma_tarih" FieldLabel="E-Fatura Mük.Olma Tarihi" Editable="false" runat="server" Width="250" />
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
                    <ext:TextField runat="server" Width="225" ID="liste_kod" FieldLabel="Liste Kodu" AllowBlank="true" RightButtonsShowMode="MouseOver">
                        <RightButtons>
                            <ext:Button runat="server" Icon="Add" />
                        </RightButtons>
                    </ext:TextField>
                    
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

                    <ext:TextField runat="server" Width="255" ID="cari_kod" FieldLabel="Müşteri Kodu" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                        <RightButtons>
                            <ext:Button runat="server" Icon="Add" />
                        </RightButtons>    
                    </ext:TextField>
                    
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
                    <ext:TextField runat="server" Width="355" ID="yetkili_kisi" FieldLabel="Görüşülen Kişi" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                        <RightButtons>
                            <ext:Button runat="server" Icon="Add" />
                        </RightButtons>
                    </ext:TextField>
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
                    <ext:TextField runat="server" Width="355" ID="unvan" FieldLabel="Ünvan" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                        <RightButtons>
                            <ext:Button runat="server" Icon="Add">
                                <Listeners>
                                    <Click Handler="#{WindowUnvan}.show();" />
                                </Listeners>
                            </ext:Button>
                        </RightButtons>
                    </ext:TextField>
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
                    <ext:ComboBox ID="urun_hizmet"
                                  runat="server"
                                  Width="146"
                                  Editable="false">
                        <Items>
                            <ext:ListItem Text="Ürün" Value="Ürün" />
                            <ext:ListItem Text="Hizmet" Value="Hizmet" />
                        </Items>
                        <SelectedItems>
                            <ext:ListItem Value="Ürün" />
                        </SelectedItems>
                    </ext:ComboBox>

                    <ext:DisplayField runat="server" Flex="1" Html="&nbsp;" />
                    <ext:TextField runat="server" FieldLabel="Ülke/İl/İlçe" Width="234" ID="ulke_kod" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                        <RightButtons>
                            <ext:Button runat="server" Icon="Add">
                                <Listeners>
                                    <Click Handler="#{PickWindowUlke}.show();" />
                                </Listeners>
                            </ext:Button>
                        </RightButtons>
                    </ext:TextField>
                    <ext:TextField runat="server" Width="230" ID="sehir_ad" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                        <RightButtons>
                            <ext:Button runat="server" Icon="Add">
                                <Listeners>
                                    <Click Handler="#{PickWindowIl}.show();" />
                                </Listeners>
                            </ext:Button>
                        </RightButtons>
                    </ext:TextField>
                    <ext:TextField runat="server" Width="230" ID="ilce_ad" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                        <RightButtons>
                            <ext:Button runat="server" Icon="Add">
                                <Listeners>
                                    <Click Handler="
                                        if (#{sehir_ad}.getValue() == '') {
                                            Ext.Msg.alert('Dikkat','Lütfen önce il seçiniz!');
                                            return;
                                        }
                                        var filter = #{sehir_ad}.getValue() + '';
                                        Ext.getStore('StoreIlce').filter('sehir_ad',filter);
                                        #{PickWindowIlce}.show();
                                    " />
                                </Listeners>
                            </ext:Button>
                        </RightButtons>
                    </ext:TextField>
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
                                    <ext:TextField runat="server" Width="304" ID="cagri_cevap" FieldLabel="Çağrı Cevap" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                                        <RightButtons>
                                            <ext:Button runat="server" Icon="Add" />
                                        </RightButtons>
                                    </ext:TextField>
                                    <ext:TextField runat="server" Width="146" ID="cagri_cevap2" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>
                    
                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="onem_derece" FieldLabel="Önem Derece" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                                        <RightButtons>
                                            <ext:Button runat="server" Icon="Add" />
                                        </RightButtons>
                                    </ext:TextField>
                                    <ext:TextField runat="server" Width="146" ID="onem_derece2" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>
                            
                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod1" FieldLabel="Cari Kat.Kod-1" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                                        <RightButtons>
                                            <ext:Button runat="server" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="
                                                        kodSira=1;
                                                        #{WindowCariKategori}.show();
                                                    " />
                                                </Listeners>
                                            </ext:Button>
                                        </RightButtons>
                                    </ext:TextField>
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad1" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>

                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod2" FieldLabel="Cari Kat.Kod-2" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                                        <RightButtons>
                                            <ext:Button runat="server" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="
                                                        kodSira=2;
                                                        #{WindowCariKategori}.show();
                                                    " />
                                                </Listeners>
                                            </ext:Button>
                                        </RightButtons>   
                                    </ext:TextField>
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad2" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>

                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod3" FieldLabel="Cari Kat.Kod-3" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                                        <RightButtons>
                                            <ext:Button runat="server" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="
                                                        kodSira=3;
                                                        #{WindowCariKategori}.show();
                                                    " />
                                                </Listeners>
                                            </ext:Button>
                                        </RightButtons>
                                    </ext:TextField>
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad3" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>

                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod4" FieldLabel="Cari Kat.Kod-4" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                                        <RightButtons>
                                            <ext:Button runat="server" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="
                                                        kodSira=4;
                                                        #{WindowCariKategori}.show();
                                                    " />
                                                </Listeners>
                                            </ext:Button>
                                        </RightButtons>
                                    </ext:TextField>
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad4" MarginSpec="0 3 0 0" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>

                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod5" FieldLabel="Cari Kat.Kod-5" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                                        <RightButtons>
                                            <ext:Button runat="server" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="
                                                        kodSira=5;      
                                                        #{WindowCariKategori}.show();
                                                    " />
                                                </Listeners>
                                            </ext:Button>
                                        </RightButtons>
                                    </ext:TextField>
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
                                <ext:TextField runat="server" Width="304" ID="cagri_nedeni" FieldLabel="Çağri Nedeni" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                                    <RightButtons>
                                        <ext:Button runat="server" Icon="Add" />
                                    </RightButtons>
                                </ext:TextField>
                                <ext:TextField runat="server" Width="264" ID="cagri_nedeni2" MarginSpec="0 3 0 0" AllowBlank="true" />
                            </Items>
                        </ext:FieldContainer>

                        <ext:FieldContainer
                            runat="server"
                            AnchorHorizontal="100%"
                            Layout="HBoxLayout">
                            <Items>
                                <ext:TextField runat="server" Width="304" ID="cagri_konusu" FieldLabel="Çağri Konusu" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver">
                                    <RightButtons>
                                        <ext:Button runat="server" Icon="Add" />
                                    </RightButtons>
                                </ext:TextField>
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
    
    <!-- il işlemleri -->

    <ext:Window ID="PickWindowIl" runat="server" Width="400" Height="410" AutoHeight="true" Title="İl"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:GridPanel
                ID="GridPanelIl"
                runat="server">
                 <Store>
                     <ext:Store ID="StoreIl" runat="server">
                         <Model>
                             <ext:Model runat="server">
                                 <Fields>
                                     <ext:ModelField Name="sehir_ad" />
                                     <ext:ModelField Name="plaka_kod" />
                                     <ext:ModelField Name="ulke_kod" />
                                     <ext:ModelField Name="telefon_kod" />
                                     <ext:ModelField Name="bolge_kod" />
                                     <ext:ModelField Name="sehirId" Type="Int" />
                                 </Fields>
                             </ext:Model>
                         </Model>
                     </ext:Store>
                 </Store>
                 <ColumnModel>
                     <Columns>
                         <ext:Column runat="server" Text="Şehir" DataIndex="sehir_ad" Width="230"/>
                     </Columns>
                 </ColumnModel>
                 <Plugins>
                    <ext:FilterHeader runat="server" />
                 </Plugins>
                 <SelectionModel>
                     <ext:RowSelectionModel runat="server" />
                 </SelectionModel>
                <BottomBar>
                    <ext:Toolbar runat="server">
                        <Items>
                            <ext:Button runat="server" Text="Seç" Icon="Accept" Handler="
                                var v= #{GridPanelIl}.getSelectionModel().getSelection();
                                if (v.length==0) return;
                                #{sehir_ad}.setValue(v[0].data.sehir_ad);
                                #{ilce_ad}.setValue('');
                                #{PickWindowIl}.hide();
                             " />
                            <ext:Button runat="server" Text="Ekle" Icon="CarAdd"  Handler="
                                #{pil_sehir_id}.setValue('0');
                                #{pil_sehir_kod}.setValue('');
                                #{pil_sehir_kod}.setReadOnly(false);
                                #{pil_ulke_kod}.setValue('');
                                #{pil_plaka_kod}.setValue('');
                                #{pil_telefon_kod}.setValue('');
                                #{pil_bolge_kod}.setValue('');
                                var filter = #{ulke_kod}.getValue() + '';
                                Ext.getStore('StoreUlke').filter('ulke_ad',filter);
                                Ext.getStore('StoreUlke').each(function(record) {
                                    #{pil_ulke_kod}.setValue(record.data.ulke_kod);
                                });          
                                #{PickWindowIlEkle}.show();
                            ">
                            </ext:Button>
                            <ext:Button runat="server" Text="Düzelt" Icon="CartEdit" Handler="
                                var v= #{GridPanelIl}.getSelectionModel().getSelection();
                                if (v.length==0) return;
                                console.log(v[0].data.sehirId);
                                #{pil_sehir_id}.setValue(v[0].data.sehirId);
                                #{pil_sehir_kod}.setValue(v[0].data.sehir_ad);
                                #{pil_sehir_kod}.setReadOnly(true);
                                #{pil_ulke_kod}.setValue(v[0].data.ulke_kod);
                                #{pil_plaka_kod}.setValue(v[0].data.plaka_kod);
                                #{pil_telefon_kod}.setValue(v[0].data.telefon_kod);
                                #{pil_bolge_kod}.setValue(v[0].data.bolge_kod);
                                #{PickWindowIlEkle}.show();
                                " />
                            <ext:Button runat="server" Text="Sil" Icon="CarDelete" Handler="
                                var v= #{GridPanelIl}.getSelectionModel().getSelection();
                                if (v.length==0) return;
                                Ext.MessageBox.show({
                                    title: 'Dikkat',
                                    msg: 'Silmek ister misiniz? ('+v[0].data.sehir_ad+')',
                                    buttons: Ext.MessageBox.OKCANCEL,
                                    icon: Ext.MessageBox.WARNING,
                                    fn: function(btn){
                                        if(btn == 'ok'){
                                            Ext.MessageBox.show({
                                                                 msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                             waitConfig: {interval:200}
	                                                            });                                            
                                        
                                            CompanyX.SehirSil(v[0].data.sehirId);
                                        }
                                    }
                                });
                                " />
                            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowIl}.hide();" />
                        </Items>
                    </ext:Toolbar>
                </BottomBar>
            </ext:GridPanel>
        </Items>
    </ext:Window>
    
    <ext:Window ID="PickWindowIlEkle" runat="server" Width="350" Height="330" AutoHeight="true" Title="Şehir Ekle/Düzelt"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:FormPanel
                ID="PickIlEkle"
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
                            FieldLabel="Şehir Id"
                            ID="pil_sehir_id"
                            Hidden="true"
                            EmptyText="Şehir Id" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="false"
                            FieldLabel="Şehir Kodu"
                            ID="pil_sehir_kod"
                            EmptyText="Şehir Kodu" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="False"
                            FieldLabel="Ülke Kodu"
                            ID="pil_ulke_kod"
                            ReadOnly="True"
                            EmptyText="Ülke Kodu" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="False"
                            FieldLabel="Plaka Kodu"
                            ID="pil_plaka_kod"
                            InputType="Number"
                            EmptyText="Plaka Kodu" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            InputType="Number"
                            AllowBlank="False"
                            FieldLabel="Telefon Kodu"
                            ID="pil_telefon_kod"
                            EmptyText="Telefon Kodu" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="True"
                            FieldLabel="Bölge Kodu"
                            ID="pil_bolge_kod"
                            ReadOnly="false"
                            EmptyText="Bölge Kodu" />
                    </Items>
                </ext:FieldSet>
                    </Items>
                    <Buttons>
                        <ext:Button runat="server" Text="Tamam" Icon="Accept" Disabled="True" FormBind="True"  Handler="#{PickWindowIlEkle}.show();">
                            <DirectEvents>
                                <Click OnEvent="IlKaydet" Before="Ext.MessageBox.show({
	                                                                      msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                                      waitConfig: {interval:200}
	                                                                    });" Delay="1">
                                    <ExtraParams>
                                        <ext:Parameter Name="Values" Value="#{PickIlEkle}.getValues(false)" Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowIlEkle}.hide();" />
                    </Buttons>
                </ext:FormPanel>
        </Items>
    </ext:Window>
    
    <!-- il işlemleri end -->

    <ext:Window ID="PickWindowIlce" runat="server" Width="400" Height="410" AutoHeight="true" Title="İlçe"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:GridPanel
                ID="GridPanelIlce"
                runat="server">
                 <Store>
                     <ext:Store ID="StoreIlce" runat="server">
                         <Model>
                             <ext:Model runat="server">
                                 <Fields>
                                     <ext:ModelField Name="sehir_ad" />
                                     <ext:ModelField Name="ilce_ad" />
                                     <ext:ModelField Name="okod1" />
                                     <ext:ModelField Name="okod2" />
                                     <ext:ModelField Name="bolge_kod" />
                                     <ext:ModelField Name="ilceId" Type="Int" />
                                 </Fields>
                             </ext:Model>
                         </Model>
                     </ext:Store>
                 </Store>
                 <ColumnModel>
                     <Columns>
                         <ext:Column runat="server" Text="İlçe" DataIndex="ilce_ad" Width="230"/>
                     </Columns>
                 </ColumnModel>
                 <Plugins>
                    <ext:FilterHeader runat="server" />
                 </Plugins>
                 <SelectionModel>
                     <ext:RowSelectionModel runat="server" />
                 </SelectionModel>
                <BottomBar>
                    <ext:Toolbar runat="server">
                        <Items>
                            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                                var v= #{GridPanelIlce}.getSelectionModel().getSelection();
                                if (v.length==0) return;
                                #{ilce_ad}.setValue(v[0].data.ilce_ad);
                                #{PickWindowIlce}.hide();
                            " />
                            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowIlce}.hide();" />
                        </Items>
                    </ext:Toolbar>
                </BottomBar>
            </ext:GridPanel>
        </Items>
    </ext:Window>
    
    <ext:Window ID="PickWindowUlke" runat="server" Width="400" Height="410" AutoHeight="true" Title="Ülke"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:GridPanel
                ID="GridPanelUlke"
                runat="server">
                 <Store>
                     <ext:Store ID="StoreUlke" runat="server">
                         <Model>
                             <ext:Model runat="server">
                                 <Fields>
                                     <ext:ModelField Name="ulke_kod" />
                                     <ext:ModelField Name="telefon_kod" />
                                     <ext:ModelField Name="trafik_kod" />
                                     <ext:ModelField Name="grup_kod" />
                                     <ext:ModelField Name="ulke_ad" />
                                     <ext:ModelField Name="ulkeId" Type="Int" />
                                 </Fields>
                             </ext:Model>
                         </Model>
                     </ext:Store>
                 </Store>
                 <ColumnModel>
                     <Columns>
                         <ext:Column runat="server" Text="Ülke" DataIndex="ulke_ad" Width="230"/>
                     </Columns>
                 </ColumnModel>
                 <Plugins>
                    <ext:FilterHeader runat="server" />
                 </Plugins>
                 <SelectionModel>
                     <ext:RowSelectionModel runat="server" />
                 </SelectionModel>
                <BottomBar>
                    <ext:Toolbar runat="server">
                        <Items>
                            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                                var v= #{GridPanelUlke}.getSelectionModel().getSelection();
                                if (v.length==0) return;
                                #{ulke_kod}.setValue(v[0].data.ulke_kod);
                                #{PickWindowUlke}.hide();
                            " />
                            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowUlke}.hide();" />
                        </Items>
                    </ext:Toolbar>
                </BottomBar>
            </ext:GridPanel>
        </Items>
    </ext:Window>
        
    <ext:Window ID="WindowCariKategori" runat="server" Width="400" Height="410" AutoHeight="true" Title="Cari Kategori"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:GridPanel
                ID="GridPanelCariKategori"
                runat="server">
                 <Store>
                     <ext:Store ID="StoreCariKategori" runat="server">
                         <Model>
                             <ext:Model runat="server">
                                 <Fields>
                                     <ext:ModelField Name="kategori_kod" />
                                     <ext:ModelField Name="kategori_ad" />
                                     <ext:ModelField Name="grup" Type="Boolean"/>
                                     <ext:ModelField Name="ckat_grup_kod" />
                                     <ext:ModelField Name="cagri_gorunmesin" Type="Boolean"/>
                                     <ext:ModelField Name="mobilcrm_gorunmesin" Type="Boolean" />
                                     <ext:ModelField Name="ckarta_eklenemez" Type="Boolean" />
                                     <ext:ModelField Name="ckatId" Type="Int" />
                                 </Fields>
                             </ext:Model>
                         </Model>
                     </ext:Store>
                 </Store>
                 <ColumnModel>
                     <Columns>
                         <ext:Column runat="server" Text="Kod" DataIndex="kategori_kod" Width="130"/>
                         <ext:Column runat="server" Text="Ad" DataIndex="kategori_ad" Width="230"/>
                     </Columns>
                 </ColumnModel>
                 <Plugins>
                    <ext:FilterHeader runat="server" />
                 </Plugins>
                 <SelectionModel>
                     <ext:RowSelectionModel runat="server" />
                 </SelectionModel>
                <BottomBar>
                    <ext:Toolbar runat="server">
                        <Items>
                            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                                console.log(kodSira);
                                var v= #{GridPanelCariKategori}.getSelectionModel().getSelection();
                                console.log(v.length);
                                if (v.length==0) return;
                                switch(kodSira) {
                                    case 1:
                                        #{ckategori_kod1}.setValue(v[0].data.kategori_kod);
                                        #{ckategori_ad1}.setValue(v[0].data.kategori_ad);
                                        break;
                                    case 2:
                                        #{ckategori_kod2}.setValue(v[0].data.kategori_kod);
                                        #{ckategori_ad2}.setValue(v[0].data.kategori_ad);
                                        break;
                                    case 3:
                                        #{ckategori_kod3}.setValue(v[0].data.kategori_kod);
                                        #{ckategori_ad3}.setValue(v[0].data.kategori_ad);
                                        break;
                                    case 4:
                                        #{ckategori_kod4}.setValue(v[0].data.kategori_kod);
                                        #{ckategori_ad4}.setValue(v[0].data.kategori_ad);
                                        break;
                                    case 5:
                                        #{ckategori_kod5}.setValue(v[0].data.kategori_kod);
                                        #{ckategori_ad5}.setValue(v[0].data.kategori_ad);
                                        break;
                                }
                               
                                #{WindowCariKategori}.hide();
                            " />
                            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{WindowCariKategori}.hide();" />
                        </Items>
                    </ext:Toolbar>
                </BottomBar>
            </ext:GridPanel>
        </Items>
    </ext:Window>

    <ext:Window ID="WindowUnvan" runat="server" Width="400" Height="410" AutoHeight="true" Title="Ünvan"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:GridPanel
                ID="GridPanelUnvan"
                runat="server">
                 <Store>
                     <ext:Store ID="StoreUnvan" runat="server">
                         <Model>
                             <ext:Model runat="server">
                                 <Fields>
                                     <ext:ModelField Name="grup_kod" />
                                     <ext:ModelField Name="unvan_kod" />
                                     <ext:ModelField Name="unvan_ad" />
                                     <ext:ModelField Name="unvanId" Type="Int" />
                                 </Fields>
                             </ext:Model>
                         </Model>
                     </ext:Store>
                 </Store>
                 <ColumnModel>
                     <Columns>
                         <ext:Column runat="server" Text="Kod" DataIndex="unvan_kod" Width="120"/>
                         <ext:Column runat="server" Text="Ad" DataIndex="unvan_ad" Width="240"/>
                     </Columns>
                 </ColumnModel>
                 <Plugins>
                    <ext:FilterHeader runat="server" />
                 </Plugins>
                 <SelectionModel>
                     <ext:RowSelectionModel runat="server" />
                 </SelectionModel>
                <BottomBar>
                    <ext:Toolbar runat="server">
                        <Items>
                            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                                var v= #{GridPanelUnvan}.getSelectionModel().getSelection();
                                if (v.length==0) return;
                                #{unvan}.setValue(v[0].data.unvan_kod);
                                #{WindowUnvan}.hide();
                            " />
                            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{WindowUnvan}.hide();" />
                        </Items>
                    </ext:Toolbar>
                </BottomBar>
            </ext:GridPanel>
        </Items>
    </ext:Window>

</body>
</html>
