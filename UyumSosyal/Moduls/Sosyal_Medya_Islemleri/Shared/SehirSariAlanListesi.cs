using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Ext.Net;
using UyumSosyal.WebReference;

namespace UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared
{
    public class SehirSariAlanListesi
    {
        public static string Remove(int masterno)
        {
            var z0 = Helper.GetWebService().HedefKitleSehirSil(masterno);
            if (!z0.Result)
                return string.IsNullOrEmpty(z0.Message) ? "Uyum'dan silinemedi, ekranı kapatıp tekrar açınız, web service cevap vermedi." : z0.Message;

            return "ok";
        }

        public static string Add(int masterno, string sehir)
        {
            var x0 = new HedefKitleSehir[1];
            var y0 = new HedefKitleSehir()
            {
                master_no = masterno,
                sehir_ad = sehir
            };
            x0[0] = y0;
            var z0 = Helper.GetWebService().HedefKitleSehirKaydet(x0);
            if (!z0.Result)
                throw new Exception("Kayıt eklemede hata!");

            return "ok";
        }


        public static List<SehirSariAlanListesiRes> GetFilterL(int start, int limit)
        {
            if (HttpContext.Current.Session["secilen"] == null) return new List<SehirSariAlanListesiRes>(); // otomatik her seferinde geliyor, diğer methodlara da ekle sunucuyu meşgul etmesin.
             
            var mId = HttpContext.Current.Session["secilen"] == null ? "0" : HttpContext.Current.Session["secilen"].ToString();
            var detay = Helper.GetWebService().HedefKitleSehirListe(mId.ToInt(), start, limit);

            var liste = Helper.GetWebService().SehirListesi(new MobServiceRequestOfMobBaseTop()
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
            var ret = new List<SehirSariAlanListesiRes>();
            foreach (var l in liste.Value)
            {
                if (!detay.Result) continue;
                var buldu = detay.Value.Any(v => v.sehir_ad == l.Desc);
                if (buldu) continue;
                ret.Add(new SehirSariAlanListesiRes()
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

        public static List<SehirSariAlanListesiRes> GetFilterR(int start, int limit)
        {
            if (HttpContext.Current.Session["secilen"] == null) return new List<SehirSariAlanListesiRes>(); // otomatik her seferinde geliyor, diğer methodlara da ekle sunucuyu meşgul etmesin.

            var mId = HttpContext.Current.Session["secilen"] == null ? "0" : HttpContext.Current.Session["secilen"].ToString();
            var detay = Helper.GetWebService().HedefKitleSehirListe(mId.ToInt(), start, limit);

            var count = detay.Value.Length;
            var ret = new List<SehirSariAlanListesiRes>();
            foreach (var l in detay.Value)
            {
                ret.Add(new SehirSariAlanListesiRes()
                {
                    code = l.sehir_ad,
                    desc = l.sehir_ad,
                    id = l.id,
                    master_no = l.master_no,
                    _count = count
                });
            }

            return ret;
        }
    }
}