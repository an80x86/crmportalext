using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Ext.Net;
using UyumSosyal.WebReference;

namespace UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared
{
    public class UrunSariAlanListesi
    {
        public static string Remove(int masterno)
        {
            var z0 = Helper.GetWebService().HedefKitleUrunSil(masterno);
            if (!z0.Result)
                return string.IsNullOrEmpty(z0.Message) ? "Uyum'dan silinemedi, ekranı kapatıp tekrar açınız, web service cevap vermedi." : z0.Message;

            return "ok";
        }

        public static string Add(int masterno, string urun)
        {
            var x0 = new HedefKitleURun[1];
            var y0 = new HedefKitleURun()
            {
                master_no = masterno,
                hizmet_urun = urun
            };
            x0[0] = y0;
            var z0 = Helper.GetWebService().HedefKitleUrunKaydet(x0);
            if (!z0.Result)
                throw new Exception("Kayıt eklemede hata!");

            return "ok";
        }

        public static List<UrunSariAlanListesiRes> GetFilterL(int start, int limit)
        {
            if (HttpContext.Current.Session["secilen"] == null) return new List<UrunSariAlanListesiRes>(); // otomatik her seferinde geliyor, diğer methodlara da ekle sunucuyu meşgul etmesin.
             
            var mId = HttpContext.Current.Session["secilen"] == null ? "0" : HttpContext.Current.Session["secilen"].ToString();
            var detay = Helper.GetWebService().HedefKitleUrunListe(mId.ToInt(), start, limit);

            var liste = Helper.GetWebService().UrunListesi(new MobServiceRequestOfMobBaseTop()
            {
                Top = 10,
                Value = new MobBaseTop() { Code = "", Desc = "" },
                Ver = ""
            });
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            var say = 0;
            var ret = new List<UrunSariAlanListesiRes>();
            foreach (var l in liste.Value)
            {
                if (!detay.Result) continue;
                var buldu = detay.Value.Any(v => v.hizmet_urun == l.Desc);
                if (buldu) continue;
                ret.Add(new UrunSariAlanListesiRes()
                {
                    code = l.Desc,
                    desc = l.Desc,
                    id = say,
                    master_no = say,
                });
                say++;
            }

            foreach (var r in ret)
            {
                r._count = ret.Count;
            }

            return ret;
        }

        public static List<UrunSariAlanListesiRes> GetFilterR(int start, int limit)
        {
            if (HttpContext.Current.Session["secilen"] == null) return new List<UrunSariAlanListesiRes>(); // otomatik her seferinde geliyor, diğer methodlara da ekle sunucuyu meşgul etmesin.

            var mId = HttpContext.Current.Session["secilen"] == null ? "0" : HttpContext.Current.Session["secilen"].ToString();
            var detay = Helper.GetWebService().HedefKitleUrunListe(mId.ToInt(), start, limit);

            var count = detay.Value.Length;
            var ret = new List<UrunSariAlanListesiRes>();
            foreach (var l in detay.Value)
            {
                ret.Add(new UrunSariAlanListesiRes()
                {
                    code = l.hizmet_urun,
                    desc = l.hizmet_urun,
                    id = l.id,
                    master_no = l.master_no,
                    _count = count
                });
            }

            return ret;
        }
    }
}