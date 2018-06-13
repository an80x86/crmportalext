//#define WST

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Threading;
using System.Globalization;
using Ext.Net;
using UyumSosyal.WebReference;


namespace UyumSosyal
{
    public class ExtNetVersion
    {
        public static Version Version = typeof(UyumSosyal.Global).Assembly.GetName().Version;

        private static string rev = (Version.Revision == 0) ? "" : ("." + Version.Revision);
        private static string bld = (Version.Build == 0) ? "" : ("." + Version.Build + rev);

        public static string Major = Version.Major + "." + Version.Minor + bld;
        public static string WithBuild = Version.Major + "." + Version.Minor + "." + Version.Build;
        public static string Full = Version.ToString();
    }

    public class WebServiceTest
    {
        public static void CariKategori()
        {
            var t = Helper.GetWebService().ParametrikAlanListesi("", "").Value;

            var ret = Helper.GetWebService().GetCKategoriListesi("").Value.CariKategori;

            var ret2 = Helper.GetWebService().CkategoriKaydet(new CariKategori()
            {
                kategori_kod="",
                kategori_ad="xxxx",
                grup = true,
                ckat_grup_kod ="",
                cagri_gorunmesin = true,
                mobilcrm_gorunmesin = true,
                ckarta_eklenemez = true,
                CkatId = 0
            });

            var ret3 = Helper.GetWebService().CKategoriSil(-99);

            var ret4 = Helper.GetWebService().CKategoriOncelikListesi("");

            var ret5 = Helper.GetWebService().CKategoriOncelikKaydet(new CkategoriOncelik()
            {
                ckategori_kod = "01 15 ",
                oncelik_ad = "test",
                oncelik_kod = "test 1"
            });

            var ret6 = Helper.GetWebService().CKategoriOncelikSil(34690406);
        }

        public static void BelgeTip()
        {
            var ret = Helper.GetWebService().BelgeTipListesi("");

            var ret2 = Helper.GetWebService().BelgeTipKaydet(new BelgeTip()
            {
                tip_kod = "test",
                aciklama = "test"
            });

            var ret3 = Helper.GetWebService().BelgeTipSil(-99);
        }

        public static void ParametrikAlan()
        {
            var ret = Helper.GetWebService().ParametrikAlanListesi("", "");

            var ret2 = Helper.GetWebService().ParametrikAlanKaydet(new KbParam()
            {
                param_kod = "kok",
                kok = "kok",
                param_ad = "kok",
                siralama_kod = "kok"
            });
        }

        public static void CariKategoriGrup()
        {
            var ret = Helper.GetWebService().CKategoriGrupListesi("");

            var ret2 = Helper.GetWebService().CKategoriGrupKaydet(new CKatGrup()
            {
                ckat_grup_ad = "test",
                ckat_grup_kod = "test"
            });
        }

        public static void Urun()
        {
            var ret = Helper.GetWebService().GenelUrunLilstesi("");

            var ret2 = Helper.GetWebService().UrunKaydet(new Urun()
            {
                grup_kod = "02",
                urun_kod = "test",
                ilk_faaliyet_sure = 2,
                arama_sikligi = 3
            });

            var ret3 = Helper.GetWebService().UrunSil(-99);
        }

        public static void Bolge()
        {
            var ret = Helper.GetWebService().BolgeListesi("");

            var ret2 = Helper.GetWebService().BolgeKaydet(new Bolge()
            {
                bolge_ad = "test",
                bolge_kod = "test test"
            });

            var ret3 = Helper.GetWebService().BolgeSil(9985025);
        }

        public static void UlkeGrup()
        {
            var ret = Helper.GetWebService().UlkeGrupListesi("");

            var ret2 = Helper.GetWebService().UlkeGrupKaydet(new UlkeGrup()
            {
                aciklama="test",
                grup_kod = "test",
                grup_ad = "test"
            });

            var ret3 = Helper.GetWebService().UlkeGrupSil(29822404);
        }

        public static void CariYetki()
        {
            var ret = Helper.GetWebService().CariYetkiliListesi("U-00050843", "");

            var ret2 = Helper.GetWebService().CariYetkiliKaydet(new CariYetkili()
            {
                cari_kod = "aaa-sil",
                unvan = "lütfen sil",
                silinsin = true
            });

            var ret3 = Helper.GetWebService().CariYetkiliSil(-99);
        }

        public static void Rakip()
        {
            var ret = Helper.GetWebService().RakipListesi(new MobServiceRequestOfMobBaseTop()
            {
                Top = 10000,
            });

            var ret2 = Helper.GetWebService().RakipKaydet(new Rakip()
            {

            });

            var ret3 = Helper.GetWebService().RakipSil(-99);
        }

        public static void Satici()
        {
            var ret = Helper.GetWebService().SaticiListesi("", "");
            var cnt = ret.Value.ToArray().FirstOrDefault(x => x.satici_kod == "test2");


            var ret2 = Helper.GetWebService().SaticiKaydet(new Satici()
            {
                satici_kod = "test2",
                satici_ad = "test2",
                aciklama = "test2",
                bolge_kod = "006-0001"
            });

            var ret3 = Helper.GetWebService().SaticiSil(-99);
        }

        public static void AltSektor()
        {
            var ret = Helper.GetWebService().AltSektorListesi("");

            var ret2 = Helper.GetWebService().AltSektorKaydet(new AltSektor()
            {
                alt_sektor_kod = "test",
                alt_sektor_ad = "test"
            });

            var ret3 = Helper.GetWebService().AltSektorSil(-99);
        }

        public static void Belge()
        {
            var ret = Helper.GetWebService().BelgeTipListesi("");

            var ret2 = Helper.GetWebService().BelgeTipKaydet(new BelgeTip()
            {
                tip_kod = "sil",
                aciklama = "sil"
            });

            var ret3 = Helper.GetWebService().BelgeTipSil(7016642);
        }

        public static void Sektor()
        {
            var ret = Helper.GetWebService().SektorMasterListe("", 0, 100000);

            var ret1 = Helper.GetWebService().SektorDetayListe(9531541, 0, 10000);

            var ret2 = Helper.GetWebService().SektorMasterKaydet(new SektorM()
            {
                sektor_ad = "sil",
                sektor_kod = "sil"
            });

            var ret3 = Helper.GetWebService().SektorDetayKaydet(new SektorD()
            {
                master_no = 9531541,
                alt_sektor_ad = "sil",
                alt_sektor_kod = "sil",
                sira_no = 99
            });

            var ret4 = Helper.GetWebService().SektorSil(-10);
            var ret5 = Helper.GetWebService().SektorDetaySil(-10);
        }
        public static void Statu()
        {
            //Listesi StatuKaydet StatuSil
            var ret = Helper.GetWebService().StatuListesi("", "");

            var sonuc = Helper.GetWebService().StatuKaydet(new Statu()
            {
                aciklama = "test",
                statu_kod = "test kod",
                statu_tip = true
            });

            var sonuc2 = Helper.GetWebService().StatuSil(-100);
        }

        public static void Sehir()
        {
            var ret = Helper.GetWebService().GenelSehirListesi("");

        }

        public static void Ilce()
        {
            var ret = Helper.GetWebService().GenelIlceListesi("");
            var ret2 = Helper.GetWebService().IlceKaydet(new Ilce()
            {
                ilce_ad = "sil",
                sehir_ad = "Bursa"
            });
        }

        public static void Ulke()
        {
            var ret = Helper.GetWebService().UlkeListesi("");

            var ret2 = Helper.GetWebService().UlkeKaydet(new Ulke()
            {
                ulke_ad = "sil",
                ulke_kod = "sil"
            });
        }
        public static void UnvanGrup()
        {
            var ret = Helper.GetWebService().UnvanGrupListesi("", "");

            var ret2 = Helper.GetWebService().UnvanGrupKaydet(new UnvanGrup()
            {
                grup_kod = "test",
                grup_ad = "test"
            });

            var ret3 = Helper.GetWebService().UnvanGrupSil(-99);
        }

        public static void Unvan()
        {
            var ret = Helper.GetWebService().UnvanListesi2("", "");

        }

        public static void Cagri()
        {
            var ret = Helper.GetWebService().CagriListesi("", DateTime.Parse("2018-04-01"), DateTime.Parse("2018-05-09"), "");

            Helper.GetWebService().CagriKaydet(new Cagri()
            {

            });
        }
    }

    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
#if WST
            int i = 0;
            i++;

            WebServiceTest.CariKategori();
            WebServiceTest.BelgeTip();
            WebServiceTest.ParametrikAlan();
            WebServiceTest.CariKategoriGrup();
            WebServiceTest.Urun();
            WebServiceTest.Bolge();
            WebServiceTest.UlkeGrup();

            WebServiceTest.CariYetki();
            WebServiceTest.Rakip();
            WebServiceTest.Satici();
            WebServiceTest.AltSektor();
            WebServiceTest.Belge();
            WebServiceTest.Sektor();
            WebServiceTest.Statu();
            WebServiceTest.Sehir();
            WebServiceTest.Ilce();
            WebServiceTest.Ulke();
            WebServiceTest.UnvanGrup();
            WebServiceTest.Unvan();
            WebServiceTest.Cagri();
#endif

            if (!Ext.Net.ResourceManager.HasFactory("mybutton"))
            {
                Ext.Net.ResourceManager.AddFactory(delegate
                {
                    var b = new Ext.Net.Button
                    {
                        Text = "Factory button",
                        Handler = "Ext.Msg.alert('Factory button', 'The button is clicked');",
                        Plugins =
                    {
                        new Badge
                        {
                            Text = "20"
                        }
                    },

                        Factory = new FactoryConfig
                        {
                            Alias = "mybutton",
                            Instance = "My.Button"
                        }
                    };

                    return b;
                }, "mybutton", "My.Button");
            }

            if (!Ext.Net.ResourceManager.HasFactory("mywindow"))
            {
                Ext.Net.ResourceManager.AddFactory("~/Examples/Miscellaneous/Factory/Basic/MyWindow.ascx", "mywindow", "My.Window");
            }
        }

        protected void Session_Start(object sender, EventArgs e)
        {
#if DEBUG
            // Enables debugging code output by default if the project is built in debug configuration.
            if (Session["Ext.Net.ScriptMode"] == null)
            {
                Session["Ext.Net.ScriptMode"] = ScriptMode.Debug;
            }

            if (Session["Ext.Net.SourceFormatting"] == null)
            {
                Session["Ext.Net.SourceFormatting"] = true;
            }
#endif // DEBUG
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AcquireRequestState(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}