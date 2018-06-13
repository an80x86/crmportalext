<%@ Page Language="C#" %>

<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="UyumSosyal" %>
<%@ Import Namespace="UyumSosyal.WebReference" %>
<%@ Import Namespace="Newtonsoft.Json.Linq" %>

<script runat="server">

    #region onload

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            ulke_kod.SetText("TÜRKİYE");
            cari_id.SetText("U-00050843");

            StoreUlke.DataSource = Helper.GetWebService().UlkeListesi("").Value;
            StoreIl.DataSource = Helper.GetWebService().GenelSehirListesi("").Value;
            StoreIlce.DataSource = Helper.GetWebService().GenelIlceListesi("").Value;
            StoreCariKategori.DataSource = Helper.GetWebService().GetCKategoriListesi("").Value.CariKategori;
            StoreCariKategoriGrup.DataSource = Helper.GetWebService().CKategoriGrupListesi("").Value;
            StoreCariKategoriListesi.DataSource = Helper.GetWebService().CariKategoriListesi("U-00050843").Value;
            StoreUnvan.DataSource = Helper.GetWebService().UnvanListesi2("", "").Value;
            StoreUnvanGrupListesi.DataSource = Helper.GetWebService().UnvanGrupListesi("", "").Value;
            StoreCariKategoriOncelik.DataSource = Helper.GetWebService().KategoriOncelikListesi("").Value;
            StoreUnvanParametrikAlanListesi.DataSource = Helper.GetWebService().ParametrikAlanListesi("", "").Value;
        }
    }

    #endregion

    #region ulke

    [DirectMethod]
    public void UlkeSil(string id)
    {
        try
        {
            var sonuc = Helper.GetWebService().UlkeSil(id.ToInt());
            X.MessageBox.Hide();
            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
            }

            StoreUlke.DataSource = Helper.GetWebService().UlkeListesi("").Value;
            StoreUlke.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }
    }

    protected void UlkeKaydet(object sender, DirectEventArgs e)
    {
        var deger = e.ExtraParams[0];
        dynamic d = JObject.Parse(deger.Value.ToString());
        try
        {
            var sonuc = Helper.GetWebService().UlkeKaydet(new Ulke()
            {
                ulke_kod = d.pulke_ulke_kod,
                grup_kod = "",
                telefon_kod = "",
                trafik_kod = "",
                ulke_ad = d.pulke_ulke_ad,
                ulkeId = int.Parse(d.pulke_ulke_id.Value.ToString())
            });
            X.MessageBox.Hide();

            if (!sonuc.Result)
            {
                X.MessageBox.Hide();
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
                return;
            }

            StoreUlke.DataSource = Helper.GetWebService().UlkeListesi("").Value;
            StoreUlke.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Hide();
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }

        PickWindowUlkeEkle.Hide();
    }

    #endregion

    #region il

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
                X.MessageBox.Hide();
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
                return;
            }

            StoreIl.DataSource = Helper.GetWebService().GenelSehirListesi("").Value;
            StoreIl.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Hide();
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

            StoreIl.DataSource = Helper.GetWebService().GenelSehirListesi("").Value;
            StoreIl.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }
    }

    #endregion

    #region ilce

    protected void IlceKaydet(object sender, DirectEventArgs e)
    {
        var deger = e.ExtraParams[0];
        dynamic d = JObject.Parse(deger.Value.ToString());
        try
        {
            var sonuc = Helper.GetWebService().IlceKaydet(new Ilce()
            {
                sehir_ad = d.pilce_sehir_ad2.Value,
                ilce_ad = d.pilce_ilce_kodu.Value,
                okod1 = "",
                okod2 = "",
                ilceId = int.Parse(d.pilce_ilce_id.Value.ToString())
            });
            X.MessageBox.Hide();

            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
                return;
            }

            StoreIlce.DataSource = Helper.GetWebService().GenelIlceListesi("").Value;
            StoreIlce.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Hide();
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }

        PickWindowIlceEkle.Hide();
    }

    [DirectMethod]
    public void IlceSil(string id)
    {
        try
        {
            var sonuc = Helper.GetWebService().IlceSil(id.ToInt());
            X.MessageBox.Hide();
            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
            }

            StoreIlce.DataSource = Helper.GetWebService().GenelIlceListesi("").Value;
            StoreIlce.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }
    }

    #endregion

    #region cari-kategori

    protected void CariKategoriKaydet(object sender, DirectEventArgs e)
    {
        var deger = e.ExtraParams[0];
        dynamic d = JObject.Parse(deger.Value.ToString());
        try
        {
            var tmp = new CariKategori()
            {
                kategori_kod = pck_kategori_kod.Value.ToString(),
                kategori_ad = pck_kategori_ad.Value.ToString(),
                grup = Helper.HasProperty(d, "pck_grup"),
                ckat_grup_kod = d.pck_ckat_grup_kod.Value,
                cagri_gorunmesin = Helper.HasProperty(d, "pck_cagri_gorunmesin"),
                mobilcrm_gorunmesin = Helper.HasProperty(d, "pck_mobilcrm_gorunmesin"),
                ckarta_eklenemez = Helper.HasProperty(d, "pck_ckarta_eklenemez"),
                CkatId = int.Parse(d.pck_ckatId.Value.ToString())
            };
            var sonuc = Helper.GetWebService().CkategoriKaydet(tmp);
            X.MessageBox.Hide();

            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
                return;
            }

            StoreCariKategori.DataSource = Helper.GetWebService().GetCKategoriListesi("").Value.CariKategori;
            StoreCariKategori.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Hide();
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }

        PickWindowCariKategoriEkle.Hide();
    }

    [DirectMethod]
    public void CariKategoriSil(string id)
    {
        try
        {
            var sonuc = Helper.GetWebService().CKategoriSil(id.ToInt());
            X.MessageBox.Hide();
            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
            }

            StoreCariKategori.DataSource = Helper.GetWebService().GetCKategoriListesi("").Value.CariKategori;
            StoreCariKategori.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }
    }

    #endregion

    #region cari-kategori-grup

    protected void CariKategoriGrupKaydet(object sender, DirectEventArgs e)
    {
        var deger = e.ExtraParams[0];
        dynamic d = JObject.Parse(deger.Value.ToString());
        try
        {
            var tmp = new CKatGrup()
            {
                grupId = int.Parse(d.pckg_grupId.Value.ToString()),
                ckat_grup_kod = d.pckg_ckat_grup_kod.Value.ToString(),
                ckat_grup_ad = d.pckg_ckat_grup_ad.Value.ToString()
            };
            var sonuc = Helper.GetWebService().CKategoriGrupKaydet(tmp);
            X.MessageBox.Hide();

            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
                return;
            }

            StoreCariKategoriGrup.DataSource = Helper.GetWebService().CKategoriGrupListesi("").Value;
            StoreCariKategoriGrup.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Hide();
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }

        PickWindowCariKategoriGrupEkle.Hide();
    }

    [DirectMethod]
    public void CariKategoriGrupSil(string id)
    {
        try
        {
            // silme de hata oluştu!..
            var sonuc = Helper.GetWebService().CKategoriGrupSil(id.ToInt());
            X.MessageBox.Hide();
            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
            }

            StoreCariKategoriGrup.DataSource = Helper.GetWebService().CKategoriGrupListesi("").Value;
            StoreCariKategoriGrup.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }
    }

    #endregion

    #region cari kategori oncelik sil

    protected void KategoriOncelikKaydet(object sender, DirectEventArgs e)
    {
        var deger = e.ExtraParams[0];
        dynamic d = JObject.Parse(deger.Value.ToString());
        try
        {
            var tmp = new KategoriOncelik()
            {
                oncelikId = int.Parse(d.poncelik_oncelikId.Value.ToString()),
                oncelik_kod = d.poncelik_oncelik_kod.Value.ToString(),
                oncelik_Ad = d.poncelik_oncelik_ad.Value.ToString()
            };
            var sonuc = Helper.GetWebService().KategoriOncelikKaydet(tmp);
            X.MessageBox.Hide();

            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
                return;
            }

            StoreCariKategoriOncelik.DataSource = Helper.GetWebService().KategoriOncelikListesi("").Value;
            StoreCariKategoriOncelik.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Hide();
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }

        PickWindowCariKategoriOncelikEkle.Hide();
    }

    [DirectMethod]
    public void KategoriOncelikSil(string id)
    {
        try
        {
            // silme de hata oluştu!..
            var sonuc = Helper.GetWebService().KategoriOncelikSil(id.ToInt());
            X.MessageBox.Hide();
            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
            }

            StoreCariKategoriOncelik.DataSource = Helper.GetWebService().KategoriOncelikListesi("").Value;
            StoreCariKategoriOncelik.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }
    }
    #endregion

    #region unvan 

    protected void UnvanKaydet(object sender, DirectEventArgs e)
    {
        var deger = e.ExtraParams[0];
        dynamic d = JObject.Parse(deger.Value.ToString());
        try
        {
            var tmp = new Unvan()
            {
                UnvanId = int.Parse(d.pcku_unvanId.Value.ToString()),
                grup_kod =  d.pcku_grup_kod.Value.ToString(),
                unvan_kod = d.pcku_unvan_kod.Value.ToString(),
                unvan_ad = d.pcku_unvan_ad.Value.ToString()
            };

            var sonuc = Helper.GetWebService().UnvanKaydet(tmp);
            X.MessageBox.Hide();

            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
                return;
            }

            StoreUnvan.DataSource = Helper.GetWebService().UnvanListesi2("", "").Value;
            StoreUnvan.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Hide();
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }

        PickWindowUnvanEkle.Hide();
    }

    [DirectMethod]
    public void UnvanSil(string id)
    {
        try
        {
            // silme de hata oluştu!..
            var sonuc = Helper.GetWebService().UnvanSil(id.ToInt());
            X.MessageBox.Hide();
            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
            }

            StoreUnvan.DataSource = Helper.GetWebService().UnvanListesi2("", "").Value;
            StoreUnvan.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }
    }

    #endregion

    #region unvan-grup

    protected void UnvanGrupListesiKaydet(object sender, DirectEventArgs e)
    {
        var deger = e.ExtraParams[0];
        dynamic d = JObject.Parse(deger.Value.ToString());
        try
        {
            var tmp = new UnvanGrup()
            {
                grupId = int.Parse(d.pckug_grupId.Value.ToString()),
                grup_kod = d.pckug_grup_kod.Value.ToString(),
                grup_ad = d.pckug_grup_ad.Value.ToString()
            };

            var sonuc = Helper.GetWebService().UnvanGrupKaydet(tmp);
            X.MessageBox.Hide();

            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
                return;
            }

            StoreUnvanGrupListesi.DataSource = Helper.GetWebService().UnvanGrupListesi("", "").Value;
            StoreUnvanGrupListesi.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Hide();
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }

        PickWindowUnvanGrupListesiEkle.Hide();
    }

    [DirectMethod]
    public void UnvanGrupListesiSil(string id)
    {
        try
        {
            // silme de hata oluştu!..
            var sonuc = Helper.GetWebService().UnvanGrupSil(id.ToInt());
            X.MessageBox.Hide();
            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
            }

            StoreUnvanGrupListesi.DataSource = Helper.GetWebService().UnvanGrupListesi("", "").Value;;
            StoreUnvanGrupListesi.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }
    }

    #endregion

    #region parametrik alan

    protected void UnvanParametrikAlanListesiKaydet(object sender, DirectEventArgs e)
    {
        var deger = e.ExtraParams[0];
        dynamic d = JObject.Parse(deger.Value.ToString());
        try
        {
            var tmp = new KbParam()
            {
                paramId = int.Parse(d.pckua_paramId.Value.ToString()),
                kok = d.pckua_kok.Value.ToString(),       
                param_kod = d.pckua_param_kod.Value.ToString(),       
                param_ad = d.pckua_param_ad.Value.ToString(),       
                siralama_kod = d.pckua_siralama_kod.Value.ToString(),       
                iskonto_yuzdesi = (decimal) Int32.Parse(d.pckua_iskonto_yuzdesi.Value.ToString()=="" ? "0" : d.pckua_iskonto_yuzdesi.Value.ToString()),       
                pasif = Helper.HasProperty(d, "pckua_pasif"),       
                faaliyet_olustur = Helper.HasProperty(d, "pckua_faaliyet_olustur")  
            };

            var sonuc = Helper.GetWebService().ParametrikAlanKaydet(tmp);
            X.MessageBox.Hide();

            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
                return;
            }

            StoreUnvanParametrikAlanListesi.DataSource = Helper.GetWebService().ParametrikAlanListesi("", "").Value;
            StoreUnvanParametrikAlanListesi.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Hide();
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }

        PickWindowUnvanParametrikAlanListesiEkle.Hide();
    }

    [DirectMethod]
    public void UnvanParametrikAlanListesiSil(string id)
    {
        try
        {
            var sonuc = Helper.GetWebService().ParametrikAlanSil(id.ToInt());
            X.MessageBox.Hide();
            if (!sonuc.Result)
            {
                X.MessageBox.Alert("Hata Oluştu", sonuc.Message).Show();
            }

            StoreUnvanParametrikAlanListesi.DataSource = Helper.GetWebService().ParametrikAlanListesi("", "").Value;
            StoreUnvanParametrikAlanListesi.DataBind();
        }
        catch (Exception ex)
        {
            X.MessageBox.Alert("Hata Oluştu", "Uyum servisi meşgul yada ulaşılamıyor.\n" + ex.Message).Show();
        }
    }

    #endregion

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

        #p_ckat_grup_kod .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #pck_ckat_grup_kod .x-form-text {
            background-image: none;
            background-color: yellow;
        }

        #pcku_grup_kod .x-form-text {
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
        var paramSira = 1;
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
                    <ext:TextField runat="server" Width="355" ID="unvan" FieldLabel="Ünvan" MarginSpec="0 3 0 0" AllowBlank="true" ReadOnly="True" RightButtonsShowMode="MouseOver">
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
                    <ext:TextField runat="server" FieldLabel="Ülke/İl/İlçe" Width="234" ID="ulke_kod" MarginSpec="0 3 0 0" AllowBlank="true" ReadOnly="True" RightButtonsShowMode="MouseOver">
                        <RightButtons>
                            <ext:Button runat="server" Icon="Add">
                                <Listeners>
                                    <Click Handler="#{PickWindowUlke}.show();" />
                                </Listeners>
                            </ext:Button>
                        </RightButtons>
                    </ext:TextField>
                    <ext:TextField runat="server" Width="230" ID="sehir_ad" MarginSpec="0 3 0 0" AllowBlank="False" ReadOnly="True" RightButtonsShowMode="MouseOver">
                        <RightButtons>
                            <ext:Button runat="server" Icon="Add">
                                <Listeners>
                                    <Click Handler="
                                        if (#{ulke_kod}.getValue() == '') {
                                            Ext.Msg.alert('Dikkat','Lütfen önce ülke seçiniz!');
                                            return;
                                        }
                                        localStorage.setItem('ulke_kod', #{ulke_kod}.getValue()+'');
                                        #{PickWindowIl}.show();
                                        " />
                                </Listeners>
                            </ext:Button>
                        </RightButtons>
                    </ext:TextField>
                    <ext:TextField runat="server" Width="230" ID="ilce_ad" MarginSpec="0 3 0 0" AllowBlank="true" ReadOnly="True" RightButtonsShowMode="MouseOver">
                        <RightButtons>
                            <ext:Button runat="server" Icon="Add">
                                <Listeners>
                                    <Click Handler="
                                        if (#{sehir_ad}.getValue() == '') {
                                            Ext.Msg.alert('Dikkat','Lütfen önce il seçiniz!');
                                            return;
                                        }
                                        var filter = #{sehir_ad}.getValue() + '';
                                        #{pilce_sehir_ad2}.setValue(filter);
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
                                    <ext:TextField runat="server" Width="304" ID="cagri_cevap" FieldLabel="Çağrı Cevap" MarginSpec="0 3 0 0" AllowBlank="true" ReadOnly="True" RightButtonsShowMode="MouseOver">
                                        <RightButtons>
                                            <ext:Button runat="server" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="
                                                        paramSira=1;
                                                        #{pckua_kok}.setValue('Çağrı Cevap');
                                                        Ext.getStore('StoreUnvanParametrikAlanListesi').filter('kok','Çağrı Cevap');
                                                        #{PickWindowUnvanParametrikAlanListesiEkle}.setTitle('Çağrı Cevap Ekle/Düzelt');
                                                        #{WindowUnvanParametrikAlanListesi}.setTitle('Çağrı Cevap');
                                                        #{WindowUnvanParametrikAlanListesi}.show();
                                                    " />
                                                </Listeners>
                                            </ext:Button>
                                        </RightButtons>
                                    </ext:TextField>
                                    <ext:TextField runat="server" Width="146" ID="cagri_cevap2" MarginSpec="0 3 0 0" ReadOnly="True" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>
                    
                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="onem_derece" FieldLabel="Önem Derece" MarginSpec="0 3 0 0" AllowBlank="true" ReadOnly="True" RightButtonsShowMode="MouseOver">
                                        <RightButtons>
                                            <ext:Button runat="server" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="
                                                        paramSira=2;
                                                        #{pckua_kok}.setValue('Çağrı Önem Derecesi');
                                                        Ext.getStore('StoreUnvanParametrikAlanListesi').filter('kok','Çağrı Önem Derecesi');
                                                        #{PickWindowUnvanParametrikAlanListesiEkle}.setTitle('Çağrı Önem Ekle/Düzelt');
                                                        #{WindowUnvanParametrikAlanListesi}.setTitle('Önem Derece');
                                                        #{WindowUnvanParametrikAlanListesi}.show();
                                                    " />
                                                </Listeners>
                                            </ext:Button>
                                        </RightButtons>
                                    </ext:TextField>
                                    <ext:TextField runat="server" Width="146" ID="onem_derece2" MarginSpec="0 3 0 0" ReadOnly="True" AllowBlank="true" />
                                </Items>
                            </ext:FieldContainer>
                            
                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod1" FieldLabel="Cari Kat.Kod-1" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver" ReadOnly="True">
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
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad1" MarginSpec="0 3 0 0" AllowBlank="true" ReadOnly="True" />
                                </Items>
                            </ext:FieldContainer>

                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod2" FieldLabel="Cari Kat.Kod-2" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver" ReadOnly="True">
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
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad2" MarginSpec="0 3 0 0" AllowBlank="true"  ReadOnly="True"/>
                                </Items>
                            </ext:FieldContainer>

                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod3" FieldLabel="Cari Kat.Kod-3" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver"  ReadOnly="True">
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
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad3" MarginSpec="0 3 0 0" AllowBlank="true"  ReadOnly="True"/>
                                </Items>
                            </ext:FieldContainer>

                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod4" FieldLabel="Cari Kat.Kod-4" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver"  ReadOnly="True">
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
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad4" MarginSpec="0 3 0 0" AllowBlank="true" ReadOnly="True"/>
                                </Items>
                            </ext:FieldContainer>

                            <ext:FieldContainer
                                runat="server"
                                AnchorHorizontal="100%"
                                Layout="HBoxLayout">
                                <Items>
                                    <ext:TextField runat="server" Width="304" ID="ckategori_kod5" FieldLabel="Cari Kat.Kod-5" MarginSpec="0 3 0 0" AllowBlank="true" RightButtonsShowMode="MouseOver"  ReadOnly="True">
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
                                    <ext:TextField runat="server" Width="146" ID="ckategori_ad5" MarginSpec="0 3 0 0" AllowBlank="true" ReadOnly="True"/>
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
                                <ext:Store ID="StoreCariKategoriListesi" runat="server">
                                    <Model>
                                        <ext:Model runat="server">
                                            <Fields>
                                                <ext:ModelField Name="cari_kod" />
                                                <ext:ModelField Name="ckategori_kod" />
                                                <ext:ModelField Name="silme_sebebi" Type="Boolean" />
                                                <ext:ModelField Name="silme_sebebi" />
                                                <ext:ModelField Name="create_date" />
                                            </Fields>
                                        </ext:Model>
                                    </Model>
                                </ext:Store>
                            </Store>
                            <ColumnModel>
                                <Columns>
                                    <ext:Column runat="server" Text="İ.Kay.Tarihi" DataIndex="create_date" Width="140"/>
                                    <ext:Column runat="server" Text="Kategori Kodu" DataIndex="ckategori_kod" Width="120"/>
                                    <ext:Column runat="server" Text="Kategori Adı" DataIndex="cari_kod" Width="270"/>
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
                                <ext:TextField runat="server" Width="304" ID="cagri_nedeni" FieldLabel="Çağri Nedeni" MarginSpec="0 3 0 0" AllowBlank="true" ReadOnly="True" RightButtonsShowMode="MouseOver">
                                    <RightButtons>
                                        <ext:Button runat="server" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="
                                                        paramSira=3;
                                                        #{pckua_kok}.setValue('Çağrı Nedeni');
                                                        Ext.getStore('StoreUnvanParametrikAlanListesi').filter('kok','Çağrı Nedeni');
                                                        #{PickWindowUnvanParametrikAlanListesiEkle}.setTitle('Çağrı Nedeni Ekle/Düzelt');
                                                        #{WindowUnvanParametrikAlanListesi}.setTitle('Çağrı Nedeni');
                                                        #{WindowUnvanParametrikAlanListesi}.show();
                                                    " />
                                                </Listeners>
                                            </ext:Button>
                                    </RightButtons>
                                </ext:TextField>
                                <ext:TextField runat="server" Width="264" ID="cagri_nedeni2" MarginSpec="0 3 0 0" ReadOnly="True" AllowBlank="true" />
                            </Items>
                        </ext:FieldContainer>

                        <ext:FieldContainer
                            runat="server"
                            AnchorHorizontal="100%"
                            Layout="HBoxLayout">
                            <Items>
                                <ext:TextField runat="server" Width="304" ID="cagri_konusu" FieldLabel="Çağri Konusu" MarginSpec="0 3 0 0" AllowBlank="true" ReadOnly="True" RightButtonsShowMode="MouseOver">
                                    <RightButtons>
                                        <ext:Button runat="server" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="
                                                        paramSira=4;
                                                        #{pckua_kok}.setValue('Çağrı Konusu');
                                                        Ext.getStore('StoreUnvanParametrikAlanListesi').filter('kok','Çağrı Konusu');
                                                        #{PickWindowUnvanParametrikAlanListesiEkle}.setTitle('Çağrı Konusu Ekle/Düzelt');
                                                        #{WindowUnvanParametrikAlanListesi}.setTitle('Çağrı Konusu');
                                                        #{WindowUnvanParametrikAlanListesi}.show();
                                                    " />
                                                </Listeners>
                                            </ext:Button>
                                    </RightButtons>
                                </ext:TextField>
                                <ext:TextField runat="server" Width="266" ID="cagri_konusu2" MarginSpec="0 3 0 0" ReadOnly="True" AllowBlank="true" />
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
    
    <!-- Ülke işlemleri -->

    <ext:Window ID="PickWindowUlke" runat="server" Width="400" Height="440" AutoHeight="true" Title="Ülke"
                Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
                LabelWidth="125" Layout="Fit">
        <BottomBar>
            <ext:Toolbar runat="server">
                <Items>
                    <ext:Label ID="LabelStatus" runat="server" Text="Sağ tuş ile düzenleme yapabilirsiniz." Width="300" />
                </Items>
            </ext:Toolbar>
        </BottomBar>
        <Items>
            <ext:GridPanel
                ID="GridPanelUlke"
                runat="server" Height="310">
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
                <Listeners>
                    <RowContextMenu Handler="
                    e.preventDefault(); 
                    #{RowContextMenuUlke}.showAt(e.getXY());
                " />
                </Listeners>
            </ext:GridPanel> 
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                    var v= App.GridPanelUlke.getSelectionModel().getSelection();
                    if (v.length==0) return;
                    #{ulke_kod}.setValue(v[0].data.ulke_kod);
                    #{PickWindowUlke}.hide();
                " />
            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowUlke}.hide();" />
        </Buttons>
    </ext:Window>
    
    <ext:Menu ID="RowContextMenuUlke" runat="server">
        <Items>
            <ext:MenuItem runat="server" Text="Ekle" Icon="CarAdd">
                <Listeners>
                    <Click Handler="
                        #{pulke_ulke_id}.setValue('0');
                        #{pulke_ulke_kod}.setValue('');
                        #{pulke_ulke_ad}.setValue('');
                        #{PickWindowUlkeEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Düzelt" Icon="CartEdit">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelUlke}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        #{pulke_ulke_id}.setValue(v[0].data.ulkeId);
                        #{pulke_ulke_kod}.setValue(v[0].data.ulke_kod);
                        #{pulke_ulke_ad}.setValue(v[0].data.ulke_ad);
                        #{PickWindowUlkeEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Sil" Icon="CarDelete">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelUlke}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        Ext.MessageBox.show({
                            title: 'Dikkat',
                            msg: 'Silmek ister misiniz? ('+v[0].data.ulke_ad+')',
                            buttons: Ext.MessageBox.OKCANCEL,
                            icon: Ext.MessageBox.WARNING,
                            fn: function(btn){
                                if(btn === 'ok'){
                                    Ext.MessageBox.show({
                                                         msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                     waitConfig: {interval:200}
	                                                    });                                            
                        
                                    CompanyX.UlkeSil(v[0].data.ulkeId);
                                }
                            }
                        });
                        " />
                </Listeners>
            </ext:MenuItem>
        </Items>
    </ext:Menu>
    
    <ext:Window ID="PickWindowUlkeEkle" runat="server" Width="350" Height="210" AutoHeight="true" Title="Ülke Ekle/Düzelt"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125">
        <LayoutConfig>
            <ext:HBoxLayoutConfig Align="Stretch" />
        </LayoutConfig>
        <Items>
            <ext:FormPanel
                ID="PickUlkeEkle"
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
                            FieldLabel="Ulke Id"
                            ID="pulke_ulke_id"
                            Hidden="true"
                            EmptyText="Ulke Id" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            InputType="Text"
                            AllowBlank="False"
                            FieldLabel="Ülke Kod"
                            ID="pulke_ulke_kod"
                            EmptyText="Ülke Kod" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="false"
                            FieldLabel="Ülke Adı"
                            ID="pulke_ulke_ad"
                            EmptyText="Ülke Adı" />
                    </Items>
                </ext:FieldSet>
                    </Items>
                    <Buttons>
                        <ext:Button runat="server" Text="Tamam" Icon="Accept" Disabled="True" FormBind="True"  Handler="#{PickWindowUlkeEkle}.show();">
                            <DirectEvents>
                                <Click OnEvent="UlkeKaydet" Before="Ext.MessageBox.show({
	                                                                      msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                                      waitConfig: {interval:200}
	                                                                    });" Delay="1">
                                    <ExtraParams>
                                        <ext:Parameter Name="Values" Value="#{PickUlkeEkle}.getValues(false)" Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowUlkeEkle}.hide();" />
                    </Buttons>
                </ext:FormPanel>
        </Items>
    </ext:Window>

    <!-- ülke işlemleri end -->

    <!-- şehir işlemleri -->

    <ext:Window ID="PickWindowIl" runat="server" Width="400" Height="440" AutoHeight="true" Title="İl"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <BottomBar>
            <ext:Toolbar runat="server">
                <Items>
                    <ext:Label ID="Label1" runat="server" Text="Sağ tuş ile düzenleme yapabilirsiniz." Width="300" />
                </Items>
            </ext:Toolbar>
        </BottomBar>
        <Items>
            <ext:GridPanel
                ID="GridPanelIl"
                runat="server" Height="310">
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
                <Listeners>
                    <RowContextMenu Handler="
                    e.preventDefault(); 
                    #{RowContextMenuIl}.showAt(e.getXY());
                " />
                </Listeners>
            </ext:GridPanel> 
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                    var v= #{GridPanelIl}.getSelectionModel().getSelection();
                    if (v.length==0) return;
                    #{sehir_ad}.setValue(v[0].data.sehir_ad);
                    #{ilce_ad}.setValue('');
                    #{PickWindowIl}.hide();
                " />
            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowIl}.hide();" />
        </Buttons>
    </ext:Window>

    <ext:Menu ID="RowContextMenuIl" runat="server">
        <Items>
            <ext:MenuItem runat="server" Text="Ekle" Icon="CarAdd">
                <Listeners>
                    <Click Handler="
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
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Düzelt" Icon="CartEdit">
                <Listeners>
                    <Click Handler="
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
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Sil" Icon="CarDelete">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelIl}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        Ext.MessageBox.show({
                            title: 'Dikkat',
                            msg: 'Silmek ister misiniz? ('+v[0].data.sehir_ad+')',
                            buttons: Ext.MessageBox.OKCANCEL,
                            icon: Ext.MessageBox.WARNING,
                            fn: function(btn){
                                if(btn === 'ok'){
                                    Ext.MessageBox.show({
                                                         msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                     waitConfig: {interval:200}
	                                                    });                                            
                        
                                    CompanyX.SehirSil(v[0].data.sehirId);
                                }
                            }
                        });
                        " />
                </Listeners>
            </ext:MenuItem>
        </Items>
    </ext:Menu>
    
    <ext:Window ID="PickWindowIlEkle" runat="server" Width="350" Height="330" AutoHeight="true" Title="İl Ekle/Düzelt"
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

    <!-- şehir işlemleri end -->
    
    <!-- ilçe işlemleri -->

    <ext:Window ID="PickWindowIlce" runat="server" Width="400" Height="410" AutoHeight="true" Title="İlçe"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <BottomBar>
            <ext:Toolbar runat="server">
                <Items>
                    <ext:Label ID="Label2" runat="server" Text="Sağ tuş ile düzenleme yapabilirsiniz." Width="300" />
                </Items>
            </ext:Toolbar>
        </BottomBar>
        <Items>
            <ext:GridPanel
                ID="GridPanelIlce"
                runat="server" Height="310">
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
                <Listeners>
                    <RowContextMenu Handler="
                    e.preventDefault(); 
                    #{RowContextMenuIlce}.showAt(e.getXY());
                " />
                </Listeners>
            </ext:GridPanel>     
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                var v= #{GridPanelIlce}.getSelectionModel().getSelection();
                if (v.length==0) return;
                #{ilce_ad}.setValue(v[0].data.ilce_ad);
                #{PickWindowIlce}.hide();
            " />
            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowIlce}.hide();" />
        </Buttons>
    </ext:Window>

    <ext:Menu ID="RowContextMenuIlce" runat="server">
        <Items>
            <ext:MenuItem runat="server" Text="Ekle" Icon="CarAdd">
                <Listeners>
                    <Click Handler="
                        #{pilce_ilce_id}.setValue('0');
                        #{pilce_ilce_kodu}.setValue('');

                        var filter = #{sehir_ad}.getValue() + '';
                        Ext.getStore('StoreIl').filter('sehir_ad',filter);
                        Ext.getStore('StoreIl').each(function(record) {
                            #{pilce_sehir_ad2}.setValue(record.data.sehir_ad);
                        });          
                        #{PickWindowIlceEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Düzelt" Icon="CartEdit">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelIlce}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        #{pilce_ilce_id}.setValue(v[0].data.ilceId);
                        #{pilce_ilce_kodu}.setValue(v[0].data.ilce_ad);
                        var filter = #{sehir_ad}.getValue() + '';
                        Ext.getStore('StoreIl').filter('sehir_ad',filter);
                        Ext.getStore('StoreIl').each(function(record) {
                            #{pilce_sehir_ad2}.setValue(record.data.sehir_ad);
                        }); 
                        #{PickWindowIlceEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Sil" Icon="CarDelete">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelIlce}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        Ext.MessageBox.show({
                            title: 'Dikkat',
                            msg: 'Silmek ister misiniz? ('+v[0].data.ilce_ad+')',
                            buttons: Ext.MessageBox.OKCANCEL,
                            icon: Ext.MessageBox.WARNING,
                            fn: function(btn){
                                if(btn === 'ok'){
                                    Ext.MessageBox.show({
                                                         msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                     waitConfig: {interval:200}
	                                                    });                                            
                                
                                    CompanyX.IlceSil(v[0].data.ilceId);
                                }
                            }
                        });
                        " />
                </Listeners>
            </ext:MenuItem>
        </Items>
    </ext:Menu>
    
    <ext:Window ID="PickWindowIlceEkle" runat="server" Width="350" Height="160" AutoHeight="true" Title="İlçe Ekle/Düzelt"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:FormPanel
                ID="PickIlceEkle"
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
                            FieldLabel="İlçe Id"
                            ID="pilce_ilce_id"
                            Hidden="true"
                            EmptyText="İlçe Id" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            InputType="Text"
                            AllowBlank="True"
                            FieldLabel="Şehir Ad"
                            ID="pilce_sehir_ad2"
                            Hidden="true"
                            EmptyText="Şehir Ad" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="false"
                            FieldLabel="İlçe Adı"
                            ID="pilce_ilce_kodu"
                            EmptyText="İlçe Adı" />
                    </Items>
                </ext:FieldSet>
                    </Items>
                    <Buttons>
                        <ext:Button runat="server" Text="Tamam" Icon="Accept" Disabled="True" FormBind="True"  Handler="#{PickWindowIlceEkle}.show();">
                            <DirectEvents>
                                <Click OnEvent="IlceKaydet" Before="Ext.MessageBox.show({
	                                                                      msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                                      waitConfig: {interval:200}
	                                                                    });" Delay="1">
                                    <ExtraParams>
                                        <ext:Parameter Name="Values" Value="#{PickIlceEkle}.getValues(false)" Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowIlceEkle}.hide();" />
                    </Buttons>
                </ext:FormPanel>
        </Items>
    </ext:Window>

    <!-- cari kategori işlemleri -->

    <ext:Window ID="WindowCariKategori" runat="server" Width="400" Height="410" AutoHeight="true" Title="Cari Kategori"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <BottomBar>
            <ext:Toolbar runat="server">
                <Items>
                    <ext:Label ID="Label3" runat="server" Text="Sağ tuş ile düzenleme yapabilirsiniz." Width="300" />
                </Items>
            </ext:Toolbar>
        </BottomBar>
        <Items>
            <ext:GridPanel
                ID="GridPanelCariKategori"
                runat="server" Height="310">
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
                                    <ext:ModelField Name="CkatId" Type="Int" />
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
                <Listeners>
                    <RowContextMenu Handler="
                    e.preventDefault(); 
                    #{RowContextMenuCariKategori}.showAt(e.getXY());
                " />
                </Listeners>
            </ext:GridPanel> 
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                        var v= App.GridPanelCariKategori.getSelectionModel().getSelection();
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
        </Buttons>
    </ext:Window>
    
    <ext:Menu ID="RowContextMenuCariKategori" runat="server">
        <Items>
            <ext:MenuItem runat="server" Text="Ekle" Icon="CarAdd">
                <Listeners>
                    <Click Handler="
                        #{pck_ckatId}.setValue('0');
                        #{pck_kategori_kod}.setValue('');
                        #{pck_kategori_ad}.setValue(''); 
                        #{pck_grup}.setValue(false);
                        #{pck_ckat_grup_kod}.setValue(''); 
                        #{pck_cagri_gorunmesin}.setValue(false);
                        #{pck_mobilcrm_gorunmesin}.setValue(false);
                        #{pck_ckarta_eklenemez}.setValue(false);
                        #{PickWindowCariKategoriEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Düzelt" Icon="CartEdit">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelCariKategori}.getSelectionModel().getSelection();
                        if (v.length==0) return;

                        #{pck_ckatId}.setValue(v[0].data.CkatId);
                        #{pck_kategori_kod}.setValue(v[0].data.kategori_kod);
                        #{pck_kategori_ad}.setValue(v[0].data.kategori_ad); 
                        #{pck_grup}.setValue(v[0].data.grup);
                        #{pck_ckat_grup_kod}.setValue(v[0].data.ckat_grup_kod); 
                        #{pck_cagri_gorunmesin}.setValue(v[0].data.cagri_gorunmesin);
                        #{pck_mobilcrm_gorunmesin}.setValue(v[0].data.mobilcrm_gorunmesin);
                        #{pck_ckarta_eklenemez}.setValue(v[0].data.ckarta_eklenemez);
                        #{PickWindowCariKategoriEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Sil" Icon="CarDelete">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelCariKategori}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        Ext.MessageBox.show({
                            title: 'Dikkat',
                            msg: 'Silmek ister misiniz? ('+v[0].data.kategori_ad+')',
                            buttons: Ext.MessageBox.OKCANCEL,
                            icon: Ext.MessageBox.WARNING,
                            fn: function(btn){
                                if(btn === 'ok'){
                                    Ext.MessageBox.show({
                                                         msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                     waitConfig: {interval:200}
	                                                    });                                            
                                
                                    CompanyX.CariKategoriSil(v[0].data.CkatId);
                                }
                            }
                        });
                        " />
                </Listeners>
            </ext:MenuItem>
        </Items>
    </ext:Menu>

    <ext:Window ID="PickWindowCariKategoriEkle" runat="server" Width="350" Height="480" AutoHeight="true" Title="Cari Kategori Ekle/Düzelt"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false"
            Layout="Fit">
        <Items>
            <ext:TabPanel
                runat="server"
                Border="false" 
                DefaultAnchor="100%">
                <Items>
                    <ext:FormPanel
                    ID="PickCariKategoriEkle"
                    runat="server"
                    DefaultAnchor="100%"
                    Title="Kategori"
                    AutoScroll="true">
                        <Items>
                            <ext:FieldSet runat="server" DefaultWidth="310" Padding="5">
                                <Items>
                                    <ext:TextField
                                        Width="290"
                                        runat="server"
                                        InputType="Number"
                                        AllowBlank="False"
                                        ID="pck_ckatId"
                                        Hidden="true" />

                                    <ext:TextField
                                        Width="290"
                                        runat="server"
                                        InputType="Text"
                                        AllowBlank="false"
                                        FieldLabel="Kod"
                                        ID="pck_kategori_kod"
                                        EmptyText="Kod" />

                                    <ext:TextField
                                        Width="290"
                                        runat="server"
                                        AllowBlank="false"
                                        FieldLabel="Ad"
                                        ID="pck_kategori_ad"
                                        EmptyText="Ad" />
                                    <ext:Checkbox runat="server" FieldLabel="Grup" ID="pck_grup" />
                                    <ext:TextField
                                        Width="290"
                                        runat="server"
                                        AllowBlank="false"
                                        FieldLabel="Kat.Grup Kod"
                                        ID="pck_ckat_grup_kod"
                                        EmptyText="Kat.Grup Kod" RightButtonsShowMode="MouseOver" ReadOnly="True">
                                        <RightButtons>
                                            <ext:Button runat="server" Icon="Add">
                                                <Listeners>
                                                    <Click Handler="#{WindowCariKategoriGrup}.show();" />
                                                </Listeners>
                                            </ext:Button>
                                        </RightButtons>
                                    </ext:TextField>
                                    <ext:Checkbox runat="server" FieldLabel="Cari Görünmesin" ID="pck_cagri_gorunmesin" />
                                    <ext:Checkbox runat="server" FieldLabel="Mobil Görünmesin" ID="pck_mobilcrm_gorunmesin" />
                                    <ext:Checkbox runat="server" FieldLabel="Cari K.Eklenemez" ID="pck_ckarta_eklenemez" />
                                </Items>
                            </ext:FieldSet>
                        </Items>

                    </ext:FormPanel>
                
                    <ext:GridPanel
                        ID="GridPanelCariKategoriOncelik"
                        runat="server" 
                        DefaultAnchor="100%" 
                        Title="Öncelik">
                        <Store>
                            <ext:Store ID="StoreCariKategoriOncelik" runat="server">
                                <Model>
                                    <ext:Model runat="server">
                                        <Fields>
                                            <ext:ModelField Name="oncelik_kod" />
                                            <ext:ModelField Name="oncelik_Ad" />
                                            <ext:ModelField Name="oncelikId" Type="Int" />
                                        </Fields>
                                    </ext:Model>
                                </Model>
                            </ext:Store>
                        </Store>
                        <ColumnModel>
                            <Columns>
                                <ext:Column runat="server" Text="Kod" DataIndex="oncelik_kod" Width="130"/>
                                <ext:Column runat="server" Text="Ad" DataIndex="oncelik_Ad" Width="230"/>
                            </Columns>
                        </ColumnModel>
                        <Plugins>
                            <ext:FilterHeader runat="server" />
                        </Plugins>
                        <SelectionModel>
                            <ext:RowSelectionModel runat="server" />
                        </SelectionModel>
                        <Listeners>
                            <RowContextMenu Handler="
                            e.preventDefault(); 
                            #{RowContextMenuCariKategoriOncelik}.showAt(e.getXY());
                        " />
                        </Listeners>
                    </ext:GridPanel>
                </Items>
            </ext:TabPanel>
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Tamam" Icon="Accept" Disabled="True" FormBind="True"  Handler="#{PickWindowCariKategoriEkle}.show();">
                <DirectEvents>
                    <Click OnEvent="CariKategoriKaydet" Before="Ext.MessageBox.show({
	                                                          msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                          waitConfig: {interval:200}
	                                                        });" Delay="1">
                        <ExtraParams>
                            <ext:Parameter Name="Values" Value="#{PickCariKategoriEkle}.getValues(false)" Mode="Raw" />
                        </ExtraParams>
                    </Click>
                </DirectEvents>
            </ext:Button>
            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowCariKategoriEkle}.hide();" />
        </Buttons>
    </ext:Window>

    <ext:Menu ID="RowContextMenuCariKategoriOncelik" runat="server">
        <Items>
            <ext:MenuItem runat="server" Text="Ekle" Icon="CarAdd">
                <Listeners>
                    <Click Handler="
                        #{poncelik_oncelikId}.setValue('0');
                        #{poncelik_oncelik_kod}.setValue('');
                        #{poncelik_oncelik_ad}.setValue(''); 
                        #{PickWindowCariKategoriOncelikEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Düzelt" Icon="CartEdit">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelCariKategoriOncelik}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        #{poncelik_oncelikId}.setValue(v[0].data.oncelikId);
                        #{poncelik_oncelik_kod}.setValue(v[0].data.oncelik_kod);
                        #{poncelik_oncelik_ad}.setValue(v[0].data.oncelik_Ad); 
                        #{PickWindowCariKategoriOncelikEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Sil" Icon="CarDelete">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelCariKategoriOncelik}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        Ext.MessageBox.show({
                            title: 'Dikkat',
                            msg: 'Silmek ister misiniz? ('+v[0].data.oncelik_Ad+')',
                            buttons: Ext.MessageBox.OKCANCEL,
                            icon: Ext.MessageBox.WARNING,
                            fn: function(btn){
                                if(btn === 'ok'){
                                    Ext.MessageBox.show({
                                                         msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                     waitConfig: {interval:200}
	                                                    });                                            
                                
                                    CompanyX.KategoriOncelikSil(v[0].data.oncelikId);
                                }
                            }
                        });
                        " />
                </Listeners>
            </ext:MenuItem>
        </Items>
    </ext:Menu>

    <ext:Window ID="PickWindowCariKategoriOncelikEkle" runat="server" Width="350" Height="200" AutoHeight="true" Title="Öncelik Ekle/Düzelt"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:FormPanel
                ID="PickCariKategoriOncelikEkle"
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
                            ID="poncelik_oncelikId"
                            Hidden="true" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            InputType="Text"
                            AllowBlank="False"
                            FieldLabel="Öncelik Kod"
                            ID="poncelik_oncelik_kod"
                            EmptyText="Öncelik Kod" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="false"
                            FieldLabel="Öncelik Ad"
                            ID="poncelik_oncelik_ad"
                            EmptyText="Öncelik Ad" />
                    </Items>
                </ext:FieldSet>
                    </Items>
                    <Buttons>
                        <ext:Button runat="server" Text="Tamam" Icon="Accept" Disabled="True" FormBind="True"  Handler="#{PickWindowCariKategoriOncelikEkle}.show();">
                            <DirectEvents>
                                <Click OnEvent="KategoriOncelikKaydet" Before="Ext.MessageBox.show({
	                                                                      msg: 'Islem yapilirken lutfen bekleyiniz.',
	                                                                      waitConfig: {interval:200}
	                                                                    });" Delay="1">
                                    <ExtraParams>
                                        <ext:Parameter Name="Values" Value="#{PickCariKategoriOncelikEkle}.getValues(false)" Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowCariKategoriOncelikEkle}.hide();" />
                    </Buttons>
                </ext:FormPanel>
        </Items>
    </ext:Window>

    <!-- cari kategori end -->

    <!-- cari kategori grup işlemleri -->
    
    <ext:Window ID="WindowCariKategoriGrup" runat="server" Width="400" Height="410" AutoHeight="true" Title="Cari Kategori Grup"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <BottomBar>
            <ext:Toolbar runat="server">
                <Items>
                    <ext:Label ID="Label4" runat="server" Text="Sağ tuş ile düzenleme yapabilirsiniz." Width="300" />
                </Items>
            </ext:Toolbar>
        </BottomBar>
        <Items>
            <ext:GridPanel
                ID="GridPanelCariKategoriGrup"
                runat="server" Height="310">
                <Store>
                    <ext:Store ID="StoreCariKategoriGrup" runat="server">
                        <Model>
                            <ext:Model runat="server">
                                <Fields>
                                    <ext:ModelField Name="ckat_grup_kod" />
                                    <ext:ModelField Name="ckat_grup_ad" />
                                    <ext:ModelField Name="grupId" Type="Int" />
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>
                        <ext:Column runat="server" Text="Kod" DataIndex="ckat_grup_kod" Width="130"/>
                        <ext:Column runat="server" Text="Ad" DataIndex="ckat_grup_ad" Width="230"/>
                    </Columns>
                </ColumnModel>
                <Plugins>
                    <ext:FilterHeader runat="server" />
                </Plugins>
                <SelectionModel>
                    <ext:RowSelectionModel runat="server" />
                </SelectionModel>
                <Listeners>
                    <RowContextMenu Handler="
                    e.preventDefault(); 
                    #{RowContextMenuCariKategoriGrup}.showAt(e.getXY());
                " />
                </Listeners>
            </ext:GridPanel> 
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                        var v= App.GridPanelCariKategoriGrup.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        #{pck_ckat_grup_kod}.setValue(v[0].data.ckat_grup_kod);
                        #{WindowCariKategoriGrup}.hide();
                    " />
            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{WindowCariKategoriGrup}.hide();" />
        </Buttons>
    </ext:Window>
    
    <ext:Menu ID="RowContextMenuCariKategoriGrup" runat="server">
        <Items>
            <ext:MenuItem runat="server" Text="Ekle" Icon="CarAdd">
                <Listeners>
                    <Click Handler="
                        #{pckg_grupId}.setValue('0');
                        #{pckg_ckat_grup_kod}.setValue('');
                        #{pckg_ckat_grup_ad}.setValue(''); 
                        #{PickWindowCariKategoriGrupEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Düzelt" Icon="CartEdit">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelCariKategoriGrup}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        #{pckg_grupId}.setValue(v[0].data.grupId);
                        #{pckg_ckat_grup_kod}.setValue(v[0].data.ckat_grup_kod);
                        #{pckg_ckat_grup_ad}.setValue(v[0].data.ckat_grup_ad); 
                        #{PickWindowCariKategoriGrupEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Sil" Icon="CarDelete">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelCariKategoriGrup}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        Ext.MessageBox.show({
                            title: 'Dikkat',
                            msg: 'Silmek ister misiniz? ('+v[0].data.ckat_grup_kod+')',
                            buttons: Ext.MessageBox.OKCANCEL,
                            icon: Ext.MessageBox.WARNING,
                            fn: function(btn){
                                if(btn === 'ok'){
                                    Ext.MessageBox.show({
                                                         msg: 'Islem yapilirken lutfen bekleyiniz.',
                                                         waitConfig: {interval:200}
                                                        });                                            
                                
                                    CompanyX.CariKategoriGrupSil(v[0].data.grupId);
                                }
                            }
                        });
                        " />
                </Listeners>
            </ext:MenuItem>
        </Items>
    </ext:Menu>

    <ext:Window ID="PickWindowCariKategoriGrupEkle" runat="server" Width="350" Height="210" AutoHeight="true" Title="Cari Kategori Grup Ekle/Düzelt"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:FormPanel
                ID="PickCariKategoriGrupEkle"
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
                            ID="pckg_grupId"
                            Hidden="true" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            InputType="Text"
                            AllowBlank="false"
                            FieldLabel="Kod"
                            ID="pckg_ckat_grup_kod"
                            EmptyText="Kod" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="false"
                            FieldLabel="Ad"
                            ID="pckg_ckat_grup_ad"
                            EmptyText="Ad" />
                    </Items>
                </ext:FieldSet>
                    </Items>
                </ext:FormPanel>
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Tamam" Icon="Accept" Disabled="True" FormBind="True"  Handler="#{PickWindowCariKategoriGrupEkle}.show();">
                <DirectEvents>
                    <Click OnEvent="CariKategoriGrupKaydet" Before="Ext.MessageBox.show({
                                                              msg: 'Islem yapilirken lutfen bekleyiniz.',
                                                              waitConfig: {interval:200}
                                                            });" Delay="1">
                        <ExtraParams>
                            <ext:Parameter Name="Values" Value="#{PickCariKategoriGrupEkle}.getValues(false)" Mode="Raw" />
                        </ExtraParams>
                    </Click>
                </DirectEvents>
            </ext:Button>
            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowCariKategoriGrupEkle}.hide();" />
        </Buttons>
    </ext:Window>

    <!-- cari kategori grup end -->

    <!-- ünvan işlemleri -->
    
    <ext:Window ID="WindowUnvan" runat="server" Width="400" Height="410" AutoHeight="true" Title="Ünvan"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <BottomBar>
            <ext:Toolbar runat="server">
                <Items>
                    <ext:Label ID="Label5" runat="server" Text="Sağ tuş ile düzenleme yapabilirsiniz." Width="300" />
                </Items>
            </ext:Toolbar>
        </BottomBar>
        <Items>
            <ext:GridPanel
                ID="GridPanelUnvan"
                runat="server" Height="310">
                <Store>
                    <ext:Store ID="StoreUnvan" runat="server">
                        <Model>
                            <ext:Model runat="server">
                                <Fields>
                                    <ext:ModelField Name="grup_kod" />
                                    <ext:ModelField Name="unvan_kod" />
                                    <ext:ModelField Name="unvan_ad" />
                                    <ext:ModelField Name="UnvanId" Type="Int" />
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>
                        <ext:Column runat="server" Text="Grup" DataIndex="grup_kod" Width="70"/>
                        <ext:Column runat="server" Text="Kod" DataIndex="unvan_kod" Width="70"/>
                        <ext:Column runat="server" Text="Ad" DataIndex="unvan_ad" Width="230"/>
                    </Columns>
                </ColumnModel>
                <Plugins>
                    <ext:FilterHeader runat="server" />
                </Plugins>
                <SelectionModel>
                    <ext:RowSelectionModel runat="server" />
                </SelectionModel>
                <Listeners>
                    <RowContextMenu Handler="
                    e.preventDefault(); 
                    #{RowContextMenuUnvan}.showAt(e.getXY());
                " />
                </Listeners>
            </ext:GridPanel> 
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                        var v= App.GridPanelUnvan.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        #{unvan}.setValue(v[0].data.unvan_kod);
                        #{WindowUnvan}.hide();
                    " />
            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{WindowUnvan}.hide();" />
        </Buttons>
    </ext:Window>

    <ext:Menu ID="RowContextMenuUnvan" runat="server">
        <Items>
            <ext:MenuItem runat="server" Text="Ekle" Icon="CarAdd">
                <Listeners>
                    <Click Handler="
                        #{pcku_unvanId}.setValue('0');
                        #{pcku_grup_kod}.setValue('');
                        #{pcku_unvan_kod}.setValue(''); 
                        #{pcku_unvan_ad}.setValue(''); 
                        #{PickWindowUnvanEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Düzelt" Icon="CartEdit">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelUnvan}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        #{pcku_unvanId}.setValue(v[0].data.UnvanId);
                        #{pcku_grup_kod}.setValue(v[0].data.grup_kod);
                        #{pcku_unvan_kod}.setValue(v[0].data.unvan_kod); 
                        #{pcku_unvan_ad}.setValue(v[0].data.unvan_ad); 
                        #{PickWindowUnvanEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Sil" Icon="CarDelete">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelUnvan}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        Ext.MessageBox.show({
                            title: 'Dikkat',
                            msg: 'Silmek ister misiniz? ('+v[0].data.unvan_ad+')',
                            buttons: Ext.MessageBox.OKCANCEL,
                            icon: Ext.MessageBox.WARNING,
                            fn: function(btn){
                                if(btn === 'ok'){
                                    Ext.MessageBox.show({
                                                         msg: 'Islem yapilirken lutfen bekleyiniz.',
                                                         waitConfig: {interval:200}
                                                        });                                            
                                
                                    CompanyX.UnvanSil(v[0].data.UnvanId);
                                }
                            }
                        });
                        " />
                </Listeners>
            </ext:MenuItem>
        </Items>
    </ext:Menu>

    <ext:Window ID="PickWindowUnvanEkle" runat="server" Width="350" Height="240" AutoHeight="true" Title="Ünvan Ekle/Düzelt"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:FormPanel
                ID="PickUnvanEkle"
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
                            ID="pcku_unvanId"
                            Hidden="true" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            InputType="Text"
                            AllowBlank="true"
                            FieldLabel="Grup"
                            ID="pcku_grup_kod"
                            EmptyText="Grup" ReadOnly="True">
                            <RightButtons>
                                <ext:Button runat="server" Icon="Add">
                                    <Listeners>
                                        <Click Handler="#{WindowUnvanGrupListesi}.show();" />
                                    </Listeners>
                                </ext:Button>
                            </RightButtons>

                        </ext:TextField>

                        <ext:TextField
                            Width="290"
                            runat="server"
                            InputType="Text"
                            AllowBlank="false"
                            FieldLabel="Kod"
                            ID="pcku_unvan_kod"
                            EmptyText="Kod" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="false"
                            FieldLabel="Ad"
                            ID="pcku_unvan_ad"
                            EmptyText="Ad" />
                    </Items>
                </ext:FieldSet>
                    </Items>
                    <Buttons>
                        <ext:Button runat="server" Text="Tamam" Icon="Accept" Disabled="True" FormBind="True"  Handler="#{PickWindowUnvanEkle}.show();">
                            <DirectEvents>
                                <Click OnEvent="UnvanKaydet" Before="Ext.MessageBox.show({
                                                                          msg: 'Islem yapilirken lutfen bekleyiniz.',
                                                                          waitConfig: {interval:200}
                                                                        });" Delay="1">
                                    <ExtraParams>
                                        <ext:Parameter Name="Values" Value="#{PickUnvanEkle}.getValues(false)" Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowUnvanEkle}.hide();" />
                    </Buttons>
                </ext:FormPanel>
        </Items>
    </ext:Window>

    <!-- ünvan end -->

    <!-- ünvan grup listesi işlemleri -->
    
    <ext:Window ID="WindowUnvanGrupListesi" runat="server" Width="400" Height="410" AutoHeight="true" Title="Ünvan Grup"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <BottomBar>
            <ext:Toolbar runat="server">
                <Items>
                    <ext:Label ID="Label6" runat="server" Text="Sağ tuş ile düzenleme yapabilirsiniz." Width="300" />
                </Items>
            </ext:Toolbar>
        </BottomBar>
        <Items>
            <ext:GridPanel
                ID="GridPanelUnvanGrupListesi"
                runat="server" Height="310">
                <Store>
                    <ext:Store ID="StoreUnvanGrupListesi" runat="server">
                        <Model>
                            <ext:Model runat="server">
                                <Fields>
                                    <ext:ModelField Name="grup_kod" />
                                    <ext:ModelField Name="grup_ad" />
                                    <ext:ModelField Name="grupId" Type="Int" />
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>
                        <ext:Column runat="server" Text="Kod" DataIndex="grup_kod" Width="130"/>
                        <ext:Column runat="server" Text="Ad" DataIndex="grup_ad" Width="230"/>
                    </Columns>
                </ColumnModel>
                <Plugins>
                    <ext:FilterHeader runat="server" />
                </Plugins>
                <SelectionModel>
                    <ext:RowSelectionModel runat="server" />
                </SelectionModel>
                <Listeners>
                    <RowContextMenu Handler="
                    e.preventDefault(); 
                    #{RowContextMenuUnvanGrupListesi}.showAt(e.getXY());
                " />
                </Listeners>
            </ext:GridPanel> 
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                        var v= App.GridPanelUnvanGrupListesi.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        #{pcku_grup_kod}.setValue(v[0].data.grup_kod);
                        #{WindowUnvanGrupListesi}.hide();
                    " />
            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{WindowUnvanGrupListesi}.hide();" />
        </Buttons>
    </ext:Window>

    <ext:Menu ID="RowContextMenuUnvanGrupListesi" runat="server">
        <Items>
            <ext:MenuItem runat="server" Text="Ekle" Icon="CarAdd">
                <Listeners>
                    <Click Handler="
                        #{pckug_grupId}.setValue('0');
                        #{pckug_grup_kod}.setValue('');
                        #{pckug_grup_ad}.setValue(''); 
                        #{PickWindowUnvanGrupListesiEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Düzelt" Icon="CartEdit">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelUnvanGrupListesi}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        #{pckug_grupId}.setValue(v[0].data.grupId);
                        #{pckug_grup_kod}.setValue(v[0].data.grup_kod);
                        #{pckug_grup_ad}.setValue(v[0].data.grup_ad); 
                        #{PickWindowUnvanGrupListesiEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Sil" Icon="CarDelete">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelUnvanGrupListesi}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        Ext.MessageBox.show({
                            title: 'Dikkat',
                            msg: 'Silmek ister misiniz? ('+v[0].data.grup_ad+')',
                            buttons: Ext.MessageBox.OKCANCEL,
                            icon: Ext.MessageBox.WARNING,
                            fn: function(btn){
                                if(btn === 'ok'){
                                    Ext.MessageBox.show({
                                                         msg: 'Islem yapilirken lutfen bekleyiniz.',
                                                         waitConfig: {interval:200}
                                                        });                                            
                                
                                    CompanyX.UnvanGrupListesiSil(v[0].data.grupId);
                                }
                            }
                        });
                        " />
                </Listeners>
            </ext:MenuItem>
        </Items>
    </ext:Menu>

    <ext:Window ID="PickWindowUnvanGrupListesiEkle" runat="server" Width="350" Height="210" AutoHeight="true" Title="Ünvan Grup Ekle/Düzelt"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:FormPanel
                ID="PickUnvanGrupListesiEkle"
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
                            ID="pckug_grupId"
                            Hidden="true" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            InputType="Text"
                            AllowBlank="false"
                            FieldLabel="Kod"
                            ID="pckug_grup_kod"
                            EmptyText="Kod" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="false"
                            FieldLabel="Ad"
                            ID="pckug_grup_ad"
                            EmptyText="Ad" />
                    </Items>
                </ext:FieldSet>
                    </Items>
                    <Buttons>
                        <ext:Button runat="server" Text="Tamam" Icon="Accept" Disabled="True" FormBind="True"  Handler="#{PickWindowUnvanGrupListesiEkle}.show();">
                            <DirectEvents>
                                <Click OnEvent="UnvanGrupListesiKaydet" Before="Ext.MessageBox.show({
                                                                          msg: 'Islem yapilirken lutfen bekleyiniz.',
                                                                          waitConfig: {interval:200}
                                                                        });" Delay="1">
                                    <ExtraParams>
                                        <ext:Parameter Name="Values" Value="#{PickUnvanGrupListesiEkle}.getValues(false)" Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowUnvanGrupListesiEkle}.hide();" />
                    </Buttons>
                </ext:FormPanel>
        </Items>
    </ext:Window>

    <!-- ünvan grup listesi end -->

    <!-- çağrı cevap / önem derecesi / çağrı nedeni / çağrı konusu -->

    <ext:Window ID="WindowUnvanParametrikAlanListesi" runat="server" Width="400" Height="410" AutoHeight="true" Title="Parametrik Alan"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <BottomBar>
            <ext:Toolbar runat="server">
                <Items>
                    <ext:Label ID="Label7" runat="server" Text="Sağ tuş ile düzenleme yapabilirsiniz." Width="300" />
                </Items>
            </ext:Toolbar>
        </BottomBar>
        <Items>
            <ext:GridPanel
                ID="GridPanelUnvanParametrikAlanListesi"
                runat="server" Height="310">
                <Store>
                    <ext:Store ID="StoreUnvanParametrikAlanListesi" runat="server">
                        <Model>
                            <ext:Model runat="server">
                                <Fields>
                                    <ext:ModelField Name="kok" />
                                    <ext:ModelField Name="param_kod" />
                                    <ext:ModelField Name="param_ad" />
                                    <ext:ModelField Name="siralama_kod" />
                                    <ext:ModelField Name="iskonto_yuzdesi" Type="Int" />
                                    <ext:ModelField Name="pasif" Type="Boolean" />
                                    <ext:ModelField Name="faaliyet_olustur" Type="Boolean" />
                                    <ext:ModelField Name="paramId" Type="Int" />
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>
                        <ext:Column runat="server" Text="Kod" DataIndex="param_kod" Width="130"/>
                        <ext:Column runat="server" Text="Ad" DataIndex="param_ad" Width="230"/>
                    </Columns>
                </ColumnModel>
                <Plugins>
                    <ext:FilterHeader runat="server" />
                </Plugins>
                <SelectionModel>
                    <ext:RowSelectionModel runat="server" />
                </SelectionModel>
                <Listeners>
                    <RowContextMenu Handler="
                    e.preventDefault(); 
                    #{RowContextMenuUnvanParametrikAlanListesi}.showAt(e.getXY());
                " />
                </Listeners>
            </ext:GridPanel> 
        </Items>
        <Buttons>
            <ext:Button runat="server" Text="Seç" Icon="Add" Handler="
                        var v= App.GridPanelUnvanParametrikAlanListesi.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        switch(paramSira) {
                            case 1:
                                #{cagri_cevap}.setValue(v[0].data.param_kod);
                                #{cagri_cevap2}.setValue(v[0].data.param_ad);
                                break;
                            case 2:
                                #{onem_derece}.setValue(v[0].data.param_kod);
                                #{onem_derece2}.setValue(v[0].data.param_ad);
                                break;
                            case 3:
                                #{cagri_nedeni}.setValue(v[0].data.param_kod);
                                #{cagri_nedeni2}.setValue(v[0].data.param_ad);
                                break;
                            case 4:
                                #{cagri_konusu}.setValue(v[0].data.param_kod);
                                #{cagri_konusu2}.setValue(v[0].data.param_ad);
                                break;
                        }
                        #{WindowUnvanParametrikAlanListesi}.hide();
                    " />
            <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{WindowUnvanParametrikAlanListesi}.hide();" />
        </Buttons>
    </ext:Window>

    <ext:Menu ID="RowContextMenuUnvanParametrikAlanListesi" runat="server">
        <Items>
            <ext:MenuItem runat="server" Text="Ekle" Icon="CarAdd">
                <Listeners>
                    <Click Handler="
                        #{pckua_paramId}.setValue('0');
                        #{pckua_param_kod}.setValue('');
                        #{pckua_param_ad}.setValue(''); 
                        #{pckua_siralama_kod}.setValue(''); 
                        #{pckua_iskonto_yuzdesi}.setValue('0'); 
                        #{pckua_pasif}.setValue(false); 
                        #{pckua_faaliyet_olustur}.setValue(false); 
                        #{PickWindowUnvanParametrikAlanListesiEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Düzelt" Icon="CartEdit">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelUnvanParametrikAlanListesi}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        #{pckua_paramId}.setValue(v[0].data.paramId);
                        #{pckua_param_kod}.setValue(v[0].data.param_kod);
                        #{pckua_param_ad}.setValue(v[0].data.param_ad); 
                        #{pckua_siralama_kod}.setValue(v[0].data.siralama_kod); 
                        #{pckua_iskonto_yuzdesi}.setValue(v[0].data.iskonto_yuzdesi); 
                        #{pckua_pasif}.setValue(v[0].data.pasif); 
                        #{pckua_faaliyet_olustur}.setValue(v[0].data.faaliyet_olustur); 
                        #{PickWindowUnvanParametrikAlanListesiEkle}.show();
                        " />
                </Listeners>
            </ext:MenuItem>
            <ext:MenuItem runat="server" Text="Sil" Icon="CarDelete">
                <Listeners>
                    <Click Handler="
                        var v= #{GridPanelUnvanParametrikAlanListesi}.getSelectionModel().getSelection();
                        if (v.length==0) return;
                        Ext.MessageBox.show({
                            title: 'Dikkat',
                            msg: 'Silmek ister misiniz? ('+v[0].data.param_ad+')',
                            buttons: Ext.MessageBox.OKCANCEL,
                            icon: Ext.MessageBox.WARNING,
                            fn: function(btn){
                                if(btn === 'ok'){
                                    Ext.MessageBox.show({
                                                         msg: 'Islem yapilirken lutfen bekleyiniz.',
                                                         waitConfig: {interval:200}
                                                        });                                            
                                
                                    CompanyX.UnvanParametrikAlanListesiSil(v[0].data.paramId);
                                }
                            }
                        });
                        " />
                </Listeners>
            </ext:MenuItem>
        </Items>
    </ext:Menu>

    <ext:Window ID="PickWindowUnvanParametrikAlanListesiEkle" runat="server" Width="350" Height="385" AutoHeight="true" Title="Çağrı Cevap Ekle/Düzelt"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Fit">
        <Items>
            <ext:FormPanel
                ID="PickUnvanParametrikAlanListesiEkle"
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
                            ID="pckua_paramId"
                            Hidden="true" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="False"
                            ID="pckua_kok"
                            Hidden="true" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            InputType="Text"
                            AllowBlank="false"
                            FieldLabel="Kod"
                            ID="pckua_param_kod"
                            EmptyText="Kod" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="false"
                            FieldLabel="Ad"
                            ID="pckua_param_ad"
                            EmptyText="Ad" />

                        <ext:TextField
                            Width="290"
                            runat="server"
                            AllowBlank="false"
                            FieldLabel="Sıralama Kodu"
                            ID="pckua_siralama_kod"
                            EmptyText="Sıralama Kodu" />

                        <ext:TextField
                            Width="180"
                            runat="server"
                            AllowBlank="false"
                            FieldLabel="İ.Yüzdesi"
                            InputType="Number"
                            ID="pckua_iskonto_yuzdesi"
                            EmptyText="%" MaxLengthText="2" />
                        <ext:Checkbox runat="server" FieldLabel="Cari Görünmesin" ID="pckua_pasif" />
                        <ext:Checkbox runat="server" FieldLabel="Cari Görünmesin" ID="pckua_faaliyet_olustur" />
                    </Items>
                </ext:FieldSet>
                    </Items>
                    <Buttons>
                        <ext:Button runat="server" Text="Tamam" Icon="Accept" Disabled="True" FormBind="True"  Handler="#{PickWindowUnvanParametrikAlanListesiEkle}.show();">
                            <DirectEvents>
                                <Click OnEvent="UnvanParametrikAlanListesiKaydet" Before="Ext.MessageBox.show({
                                                                          msg: 'Islem yapilirken lutfen bekleyiniz.',
                                                                          waitConfig: {interval:200}
                                                                        });" Delay="1">
                                    <ExtraParams>
                                        <ext:Parameter Name="Values" Value="#{PickUnvanParametrikAlanListesiEkle}.getValues(false)" Mode="Raw" />
                                    </ExtraParams>
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button runat="server" Text="Kapat" Icon="Door" Handler="#{PickWindowUnvanParametrikAlanListesiEkle}.hide();" />
                    </Buttons>
                </ext:FormPanel>
        </Items>
    </ext:Window>
    
    <!-- çağrı cevap / önem derecesi / çağrı nedeni / çağrı konusu end -->
</body>
</html>
