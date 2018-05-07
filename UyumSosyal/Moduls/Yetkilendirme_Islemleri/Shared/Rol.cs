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


namespace UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared
{
    public class Rol
    {
        public static string Remove(int id)
        {
            var z0 = Helper.GetWebService().PortalRolSil(id);
            if (!z0.Result)
                return z0.Message;

            return "ok";
        }

        public static string Save(string id, string rolKod, string aciklama)
        {
            var x0 = new WebReference.RolRes[1];
            var y0 = new WebReference.RolRes()
            {
                id = id == "" ? 0 : id.ToInt(),
                rol_kod = rolKod,
                aciklama = aciklama
            };
            x0[0] = y0;
            var z0 = Helper.GetWebService().InsertRol(x0);
            if (!z0.Result)
                return z0.Message;

            return "ok";
        }

        public static List<RolRes> GetFilter(int start, int limit, DataSorter sort, out int count, string arax)
        {
            var liste = Helper.GetWebService().PortalRolList("", start, limit);
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            count = liste.Value.totalcount;
            var ret = new List<RolRes>(liste.Value.totalcount);
            ret.AddRange(liste.Value.RolListesi.Select(l => new RolRes()
            {
                aciklama = l.aciklama,
                rol_kod = l.rol_kod,
                _count = liste.Value.totalcount
            }));

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "rol_kod" : sort.Property;

            // filtreleme
            if (!string.IsNullOrEmpty(orderBy) && arax.Trim() != "")
            {
                switch (orderBy)
                {
                    case "rol_kod":
                        ret = ret.Where(x => x.rol_kod.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "aciklama":
                        ret = ret.Where(x => x.aciklama.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                }
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