using Ext.Net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UyumSosyal.WebReference;
using PortalYetkiRes = UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.Dto.PortalYetkiRes;

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
                aspnet_rol_id = aspnet_rol_id,
                aspnet_modul_id = aspnet_modul_id,
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

        public static RolRes[] GetRols()
        {
            var rol = Helper.GetWebService().PortalRolList("", Helper.MIN, Helper.MAX);
            if (!string.IsNullOrEmpty(rol.Message))
            {
                throw new Exception(rol.Message);
            }

            return rol.Value.RolListesi;
        }

        public static ModulRes[] GetModuls()
        {
            var modul = Helper.GetWebService().PortalModulList("", Helper.MIN, Helper.MAX);
            if (!string.IsNullOrEmpty(modul.Message))
            {
                throw new Exception(modul.Message);
            }

            return modul.Value.ModulListesi;
        }

        public static List<Dto.PortalYetkiRes> GetFilter(int start, int limit, DataSorter sort, out int count, string arax)
        {
            var liste = Helper.GetWebService().PortalYetkiList(0,0, start, limit);
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            var rols = GetRols().ToArray();
            var moduls = GetModuls().ToArray();

            count = liste.Value.totalcount;
            var ret = new List<Dto.PortalYetkiRes>(liste.Value.totalcount);
            ret.AddRange(liste.Value.YetkiListesi.Select(l => new Dto.PortalYetkiRes()
            {
                id = l.id,
                aspnet_rol_id = l.aspnet_rol_id,
                aspnet_modul_id = l.aspnet_modul_id,
                rol_kod = rols.FirstOrDefault(x => x.id == l.aspnet_rol_id)?.rol_kod,
                modul_kod = moduls.FirstOrDefault(x=> x.id == l.aspnet_modul_id)?.modul_kod,
                is_yazma = l.is_yazma ? "evet" : "hayır",
                is_silme = l.is_silme ? "evet" : "hayır",
                is_okuma = l.is_okuma ? "evet" : "hayır",
                is_olusturma = l.is_olusturma ? "evet" : "hayır",
                _count = liste.Value.totalcount
            }));

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "rol_kod" : sort.Property;

            // filtreleme
            if (!string.IsNullOrEmpty(orderBy) && arax.Trim() != "")
            {
                ret = ret = ret.Where(
                    x => x.modul_kod.ToLower().Contains(arax.ToLower()) ||
                         x.rol_kod.ToLower().Contains(arax.ToLower()) ||
                         x.rol_kod.ToLower().Contains(arax.ToLower()) ||
                         x.is_okuma.ToLower().Contains(arax.ToLower()) ||
                         x.is_olusturma.ToLower().Contains(arax.ToLower()) ||
                         x.is_silme.ToLower().Contains(arax.ToLower()) ||
                         x.is_yazma.ToLower().Contains(arax.ToLower()) 
                ).ToList();
                count = ret.Count;
            }

            var dynamicPropFromStr = typeof(PortalYetkiRes).GetProperty(orderBy);

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