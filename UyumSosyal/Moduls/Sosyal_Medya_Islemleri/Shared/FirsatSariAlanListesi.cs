using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Ext.Net;
using UyumSosyal.WebReference;

namespace UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared
{
    public class FirsatSariAlanListesi
    {
        public static string Remove(int masterno)
        {
            var z0 = Helper.GetWebService().HedefKitleFirsatSil(masterno);
            if (!z0.Result)
                return string.IsNullOrEmpty(z0.Message) ? "Uyum'dan silinemedi, ekranı kapatıp tekrar açınız, web service cevap vermedi." : z0.Message;

            return "ok";
        }

        public static string Add(int masterno, string firsat)
        {
            var x0 = new HedefKitleFirsat[1];
            var y0 = new HedefKitleFirsat()
            {
                master_no = masterno,
                firsat_statu = firsat
            };
            x0[0] = y0;
            var z0 = Helper.GetWebService().HedefKitleFirsatKaydet(x0);
            if (!z0.Result)
                throw new Exception("Kayıt eklemede hata!");

            return "ok";
        }

        public static List<FirsatSariAlanListesiRes> GetFilterL(int start, int limit)
        {
            if (HttpContext.Current.Session["secilen"] == null) return new List<FirsatSariAlanListesiRes>(); // otomatik her seferinde geliyor, diğer methodlara da ekle sunucuyu meşgul etmesin.
             
            var mId = HttpContext.Current.Session["secilen"] == null ? "0" : HttpContext.Current.Session["secilen"].ToString();
            var detay = Helper.GetWebService().HedefKitleFirsatListe(mId.ToInt(), start, limit);

            var fake = new string[]
            {
                "Kazanıldı",
                "Kaybedildi",
                "Ertelendi",
                "Vazgeçildi",
                "Devam Ediyor",
                "Fes Edildi",
                "Postansiye Değil"
            };

            var liste = fake.Select(f => new FirsatSariAlanListesiRes() {code = f, desc = f, _count = fake.Length, master_no = 0}).ToList();

            var say = 0;
            var ret = new List<FirsatSariAlanListesiRes>();
            foreach (var l in liste)
            {
                if (!detay.Result) continue;
                var buldu = detay.Value.Any(v => v.firsat_statu == l.desc);
                if (buldu) continue;
                ret.Add(new FirsatSariAlanListesiRes()
                {
                    code = l.desc,
                    desc = l.desc,
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

        public static List<FirsatSariAlanListesiRes> GetFilterR(int start, int limit)
        {
            if (HttpContext.Current.Session["secilen"] == null) return new List<FirsatSariAlanListesiRes>(); // otomatik her seferinde geliyor, diğer methodlara da ekle sunucuyu meşgul etmesin.

            var mId = HttpContext.Current.Session["secilen"] == null ? "0" : HttpContext.Current.Session["secilen"].ToString();
            var detay = Helper.GetWebService().HedefKitleFirsatListe(mId.ToInt(), start, limit);

            var count = detay.Value.Length;
            var ret = new List<FirsatSariAlanListesiRes>();
            foreach (var l in detay.Value)
            {
                ret.Add(new FirsatSariAlanListesiRes()
                {
                    code = l.firsat_statu,
                    desc = l.firsat_statu,
                    id = l.id,
                    master_no = l.master_no,
                    _count = count
                });
            }

            return ret;
        }
    }
}