using System;
using System.Collections.Generic;
using System.Linq;
using Ext.Net;
using UyumSosyal.WebReference;
using System.Net;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Web.Services;
using UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.Dto;

namespace UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared
{
    public class Modul
    {
        public static string Remove(int id)
        {
            var z0 = Helper.GetWebService().PortalModulSil(id);
            if (!z0.Result)
                return z0.Message;

            return "ok";
        }

        public static string Save(string id, string modulKod, string modulPath, string aciklama, bool durum)
        {
            var x0 = new WebReference.ModulRes[1];
            var y0 = new WebReference.ModulRes()
            {
                id = id == "" ? 0 : id.ToInt(),
                modul_kod = modulKod,
                modul_path = modulPath,
                aciklama = aciklama,
                durum = durum
            };
            x0[0] = y0;
            var z0 = Helper.GetWebService().InsertModul(x0);
            if (!z0.Result)
                return z0.Message;

            return "ok";
        }

        public static List<Dto.ModulRes> GetFilter(int start, int limit, DataSorter sort, out int count, string arax)
        {
            var liste = Helper.GetWebService().PortalModulList("", start, limit);
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            count = liste.Value.totalcount;
            var ret = new List<Dto.ModulRes>(liste.Value.totalcount);
            ret.AddRange(liste.Value.ModulListesi.Select(l => new Dto.ModulRes()
            {
                aciklama = l.aciklama,
                durum = l.durum,
                id = l.id,
                modul_kod = l.modul_kod,
                modul_path = l.modul_path,
                _count = liste.Value.totalcount
            }));

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "modul_kod" : sort.Property;

            // filtreleme
            if (!string.IsNullOrEmpty(orderBy) && arax.Trim() != "")
            {
                switch (orderBy)
                {
                    case "modul_kod":
                        ret = ret.Where(x => x.modul_kod.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "modul_path":
                        ret = ret.Where(x => x.modul_path.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "aciklama":
                        ret = ret.Where(x => x.aciklama.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                }
            }

            var dynamicPropFromStr = typeof(Dto.ModulRes).GetProperty(orderBy);

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