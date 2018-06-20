using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Ext.Net;

namespace UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared
{
    public class HedefKitleM
    {
        public static string Remove(int masterno)
        {
            var z0 = Helper.GetWebService().HedefKitleMasterSil(masterno);
            if (!z0.Result)
                return string.IsNullOrEmpty(z0.Message) ? "Uyum'dan silinemedi, ekranı kapatıp tekrar açınız, web service cevap vermedi." : z0.Message;

            return "ok";
        }

        public static string Save(string masterNo, string hedefListeId, string hedefListeAd, string aciklama, string telefonMail)
        {
            var x0 = new WebReference.HedefKitleM[1];
            var y0 = new WebReference.HedefKitleM()
            {
                master_no = string.IsNullOrEmpty(masterNo) ? 0 : masterNo.ToInt(),
                telefon_mail = telefonMail,
                aciklama = aciklama,
                hedef_liste_ad = hedefListeAd,
                hedef_liste_id = hedefListeId
            };
            x0[0] = y0;
            var z0 = Helper.GetWebService().HedefKitleMasterKaydet(x0);
            if (!z0.Result)
                return z0.Message;

            return "ok";
        }

        public static List<HedefKitleMRes> GetFilter(int start, int limit, DataSorter sort, out int count, string arax)
        {
            //var liste = Helper.GetWebService().HedefKitleMasterListe(arax,start,limit); // arama çalışmıyor.
            var liste = Helper.GetWebService().HedefKitleMasterListe("",start,limit);
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            count = liste.Value.Length;
            var tmpCount = liste.Value.Length;
            var ret = new List<HedefKitleMRes>(tmpCount);
            ret.AddRange(liste.Value.Select(l => new HedefKitleMRes()
            {
                master_no = l.master_no,
                _count = tmpCount,
                hedef_liste_ad = l.hedef_liste_ad,
                hedef_liste_id = l.hedef_liste_id,
                aciklama = l.aciklama,
                telefon_mail = l.telefon_mail
            }));

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "hedef_liste_id" : sort.Property;

            // filtreleme
            if (!string.IsNullOrEmpty(orderBy) && arax.Trim() != "")
            {
                switch (orderBy)
                {
                    case "hedef_liste_ad":
                        ret = ret.Where(x => x.hedef_liste_ad.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "hedef_liste_id":
                        ret = ret.Where(x => x.hedef_liste_id.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "aciklama":
                        ret = ret.Where(x => x.aciklama.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "telefon_mail":
                        ret = ret.Where(x => x.telefon_mail.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                }
            }

            var dynamicPropFromStr = typeof(HedefKitleMRes).GetProperty(orderBy);
            if (sort.Direction == SortDirection.ASC)
            {
                ret = ret.OrderBy(x => dynamicPropFromStr.GetValue(x, null)).ToList();
            }
            else
            {
                ret = ret.OrderByDescending(x => dynamicPropFromStr.GetValue(x, null)).ToList();
            }

            return ret;
        }
    }
}