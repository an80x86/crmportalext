using Ext.Net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared
{
    public class PortalYetki
    {
        public static string Remove(int id)
        {
            var z0 = Helper.GetWebService().PortalYetkiSil(id);
            if (!z0.Result)
                return z0.Message;

            return "ok";
        }

        public static string Save(string id, int aspnet_modul_id, int aspnet_rol_id, bool is_okuma, bool is_yazma, bool is_silme, bool is_olusturma)
        {
            var x0 = new WebReference.PortalYetkiRes[1];
            var y0 = new WebReference.PortalYetkiRes()
            {
                id = id == "" ? 0 : id.ToInt(),
                aspnet_rol_id = aspnet_modul_id,
                aspnet_modul_id = aspnet_rol_id,
                is_yazma = is_yazma,
                is_silme = is_silme,
                is_okuma = is_okuma,
                is_olusturma = is_olusturma
            };
            x0[0] = y0;
            var z0 = Helper.GetWebService().InsertPortalYetki(x0);
            if (!z0.Result)
                return z0.Message;

            return "ok";
        }

        public static List<PortalYetkiRes> GetFilter(int start, int limit, DataSorter sort, out int count, string arax)
        {
            
            var liste = Helper.GetWebService().PortalYetkiList(0,0, start, limit);
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            count = liste.Value.totalcount;
            var ret = new List<PortalYetkiRes>(liste.Value.totalcount);
            ret.AddRange(liste.Value.YetkiListesi.Select(l => new PortalYetkiRes()
            {
                id = l.id,
                aspnet_rol_id = l.aspnet_rol_id,
                aspnet_modul_id = l.aspnet_modul_id,
                is_yazma = l.is_yazma,
                is_silme = l.is_silme,
                is_okuma = l.is_okuma,
                is_olusturma = l.is_olusturma,
                _count = liste.Value.totalcount
            }));

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "modul_kod" : sort.Property;

            // filtreleme
            if (!string.IsNullOrEmpty(orderBy) && arax.Trim() != "")
            {
                /*
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
                */
            }

            var dynamicPropFromStr = typeof(ModulRes).GetProperty(orderBy);

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