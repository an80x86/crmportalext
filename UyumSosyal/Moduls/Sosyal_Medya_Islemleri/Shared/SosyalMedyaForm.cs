using System;
using System.Collections.Generic;
using System.Linq;
using Ext.Net;
using UyumSosyal.WebReference;
using System.Net;
using System.Configuration;
using System.Linq.Expressions;
using System.Security.Cryptography;
using System.Text;
using System.Web.Services;

namespace UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared
{
    public class SosyalMedyaForm
    {
        public static string Remove(int masterno)
        {
            var z0 = Helper.GetWebService().SosyalMedyaFormSil(masterno);
            if (!z0.Result)
                return string.IsNullOrEmpty(z0.Message) ? "Uyum'dan silinemedi, ekranı kapatıp tekrar açınız, web service cevap vermedi." : z0.Message;

            return "ok";
        }

        public static string Save(string masterNo, string formId, string formAd, string formTip, bool pasif)
        {
            var x0 = new WebReference.SosyalMedyaFormRes[1];
            var y0 = new WebReference.SosyalMedyaFormRes()
            {
                master_no = string.IsNullOrEmpty(masterNo) ? 0 : masterNo.ToInt(),
                form_id =  formId,
                form_ad = formAd,
                form_tip = formTip,
                pasif = pasif
            };
            x0[0] = y0;
            var z0 = Helper.GetWebService().SosyalMedyaFormKaydet(x0);
            if (!z0.Result)
                return z0.Message;

            return "ok";
        }

        public static List<SosyalMedyaFormRes> GetFilter(int start, int limit, DataSorter sort, out int count, string arax)
        {
            var liste = Helper.GetWebService().SosyalMedyaFormListesi("", DateTime.Now.AddYears(-1), DateTime.Now.AddYears(1));//, start, limit);
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            count = liste.Value.Length;
            var tmpCount = liste.Value.Length;
            var ret = new List<SosyalMedyaFormRes>(tmpCount);
            ret.AddRange(liste.Value.Select(l => new SosyalMedyaFormRes()
            {
                master_no = l.master_no,
                _count = tmpCount,
                form_ad = l.form_ad,
                form_id = l.form_id,
                form_tip = l.form_tip,
                pasif = l.pasif
            }));

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "form_ad" : sort.Property;

            // filtreleme
            if (!string.IsNullOrEmpty(orderBy) && arax.Trim() != "")
            {
                switch (orderBy)
                {
                    case "form_id":
                        ret = ret.Where(x => x.form_id.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "form_ad":
                        ret = ret.Where(x => x.form_ad.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "form_tip":
                        ret = ret.Where(x => x.form_tip.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                }
            }

            var dynamicPropFromStr = typeof(SosyalMedyaFormRes).GetProperty(orderBy);
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