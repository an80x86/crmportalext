using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Ext.Net;
using UyumSosyal.WebReference;

namespace UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared
{
    public class SektorSariAlanListesi
    {
        public static string Remove(int id)
        {
            var z0 = Helper.GetWebService().HedefKitleSektorSil(id);
            if (!z0.Result)
                return string.IsNullOrEmpty(z0.Message) ? "Uyum'dan silinemedi, ekranı kapatıp tekrar açınız, web service cevap vermedi." : z0.Message;

            return "ok";
        }

        public static string Add(int masterno, string sektor)
        {
            var x0 = new HedefKitleSektor[1];
            var y0 = new HedefKitleSektor()
            {
                master_no = masterno,
                sektor_kod = sektor
            };
            x0[0] = y0;
            var z0 = Helper.GetWebService().HedefKitleSektorKaydet(x0);
            if (!z0.Result)
                throw new Exception("Kayıt eklemede hata!");

            return "ok";
        }

        public static List<SektorSariAlanListesiRes> GetFilterL(int start, int limit)
        {
            if (HttpContext.Current.Session["secilen"] == null) return new List<SektorSariAlanListesiRes>(); // otomatik her seferinde geliyor, diğer methodlara da ekle sunucuyu meşgul etmesin.
             
            var mId = HttpContext.Current.Session["secilen"] == null ? "0" : HttpContext.Current.Session["secilen"].ToString();
            var detay = Helper.GetWebService().HedefKitleSektorListe(mId.ToInt(), start, limit);

            var liste = Helper.GetWebService().SektorListesi(new MobServiceRequestOfMobBaseTop()
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
            var ret = new List<SektorSariAlanListesiRes>();
            foreach (var l in liste.Value)
            {
                if (!detay.Result) continue;
                var buldu = detay.Value.Any(v => v.sektor_kod == l.Code);
                if (buldu) continue;
                ret.Add(new SektorSariAlanListesiRes()
                {
                    code = l.Code,
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

        public static List<SektorSariAlanListesiRes> GetFilterR(int start, int limit)
        {
            if (HttpContext.Current.Session["secilen"] == null) return new List<SektorSariAlanListesiRes>(); // otomatik her seferinde geliyor, diğer methodlara da ekle sunucuyu meşgul etmesin.

            var mId = HttpContext.Current.Session["secilen"] == null ? "0" : HttpContext.Current.Session["secilen"].ToString();
            var detay = Helper.GetWebService().HedefKitleSektorListe(mId.ToInt(), start, limit);

            // master listeyi yukle
            var liste = Helper.GetWebService().SektorListesi(new MobServiceRequestOfMobBaseTop()
            {
                Top = 10,
                Value = new MobBaseTop() { Code = "", Desc = "" },
                Ver = ""
            });
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            var count = detay.Value.Length;
            var ret = new List<SektorSariAlanListesiRes>();
            foreach (var l in detay.Value)
            {
                ret.Add(new SektorSariAlanListesiRes()
                {
                    code = l.sektor_kod,
                    desc = liste.Value.FirstOrDefault(z => z.Code == l.sektor_kod)?.Desc,
                    id = l.id,
                    master_no = l.master_no,
                    _count = count
                });
            }

            return ret;
        }
    }
}