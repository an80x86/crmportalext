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
    public class UserRol
    {
        public static RolRes[] GetRols()
        {
            var rol = Helper.GetWebService().PortalRolList("", Helper.MIN, Helper.MAX);
            if (!string.IsNullOrEmpty(rol.Message))
            {
                throw new Exception(rol.Message);
            }

            return rol.Value.RolListesi;
        }

        public static UserRes[] GetUsers()
        {
            var liste = Helper.GetWebService().PortalUserList("", Helper.MIN, Helper.MAX);
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            return liste.Value.KullaniciListesi;
        }

        public static string Remove(int id)
        {
            var z0 = Helper.GetWebService().PortalKullaniciRolSil(id);
            if (!z0.Result)
                return z0.Message;

            return "ok";
        }

        public static string Save(string id, string rolId, string userId)
        {
            var x0 = new WebReference.UserRolRes[1];
            var y0 = new WebReference.UserRolRes()
            {
                id = id == "" ? 0 : id.ToInt(),
                rol_id = rolId.ToInt(),
                aspnet_kullanici_id = userId.ToInt()
            };
            x0[0] = y0;
            var z0 = Helper.GetWebService().InsertUserRol(x0);
            if (!z0.Result)
                return z0.Message;

            return "ok";
        }

        public static List<Dto.UserRolRes> GetFilter(int start, int limit, DataSorter sort, out int count, string arax)
        {
            var rols = GetRols().ToArray();
            var users = GetUsers().ToArray();

            //var liste = Helper.GetWebService().PortalUSerRolList(0, start, limit); // sifir gelince problem cikiyor
            var liste = Helper.GetWebService().PortalUSerRolList(0, start, limit);
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            count = liste.Value.totalcount;
            var ret = new List<Dto.UserRolRes>(liste.Value.totalcount);
            ret.AddRange(liste.Value.KullaniciRolListesi.Select(l => new Dto.UserRolRes()
            {
                id = l.id,
                aspnet_rol_id = l.rol_id,
                rol = rols.FirstOrDefault(x => x.id == l.rol_id)?.rol_kod,
                aspnet_kullanici_id = l.aspnet_kullanici_id,
                kullanici = users.FirstOrDefault(x => x.id == l.aspnet_kullanici_id)?.user_kod,
                _count = liste.Value.totalcount
            }));

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "aspnet_kullanici_id" : sort.Property;

            // filtreleme
            if (!string.IsNullOrEmpty(orderBy) && arax.Trim() != "")
            {
                switch (orderBy)
                {
                    case "aspnet_rol_id":
                        ret = ret.Where(x => x.aspnet_rol_id.ToString().ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "aspnet_kullanici_id":
                        ret = ret.Where(x => x.aspnet_kullanici_id.ToString().ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                }
            }

            var dynamicPropFromStr = typeof(Dto.UserRolRes).GetProperty(orderBy);

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