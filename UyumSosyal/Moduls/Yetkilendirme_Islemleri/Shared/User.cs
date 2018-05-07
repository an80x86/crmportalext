using System;
using System.Collections.Generic;
using System.Linq;
using Ext.Net;
using UyumSosyal.WebReference;
using System.Net;
using System.Configuration;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Web.Caching;
using System.Web.Services;
using System.Web;
using Ext.Net.Utilities;

namespace UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared
{
    public class User
    {
        public static string Remove(int id)
        {
            var z0 = Helper.GetWebService().PortalKullaniciSil(id);
            if (!z0.Result)
                return z0.Message;

            ReLoad();
            return "ok";
        }

        public static string Save(string id, string userKod, string ad, string soyad, string sifre, bool durum)
        {
            var x0 = new WebReference.UserRes[1];
            var y0 = new WebReference.UserRes()
            {
                id = id == "" ? 0 : id.ToInt(),
                user_kod = userKod,
                user_ad = ad,
                user_soyad = soyad,
                user_sifre = sifre.Md5Hash(),
                durum = durum
            };
            x0[0] = y0;
            var z0 = Helper.GetWebService().InsertPortalUSer(x0);
            if (!z0.Result)
                return z0.Message;

            ReLoad();
            return "ok";
        }

        private static List<UserRes> GetData(int start, int limit, out int count, string arax)
        {
            //var liste = Helper.GetWebService().PortalUserList(arax, start, limit);
            var liste = Helper.GetWebService().PortalUserList("", start, limit);
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            count = liste.Value.totalcount;
            var ret = new List<UserRes>(liste.Value.totalcount);
            ret.AddRange(liste.Value.KullaniciListesi.Select(l => new UserRes()
            {
                durum = l.durum,
                id = l.id,
                user_ad = l.user_ad,
                user_kod = l.user_kod,
                user_sifre = l.user_sifre,
                user_soyad = l.user_soyad,
                _count = liste.Value.totalcount
            }));

            return ret;
        }

        private static List<UserRes> GetCustomers(int start, int limit, out int count, string arax, bool bypassCache = true)
        {
            var cache = (List<UserRes>) HttpRuntime.Cache["UserRes"];
            if (bypassCache || cache == null)
            {
                cache = GetData(start, limit, out count, arax);

                HttpRuntime.Cache.Insert(
                    "UserRes",
                    cache,
                    null,
                    DateTime.Now.AddHours(ConfigurationManager.AppSettings["cachetime"].ToInt()),
                    System.Web.Caching.Cache.NoSlidingExpiration
                );

                return cache;
            }
            else
            {
                count = cache.Count; 
                return cache;
            }
        }

        private static void ReLoad()
        {
            int count;
            GetCustomers(0, 1000, out count, "", true);
        }

        public static List<UserRes> GetFilter(int start, int limit, DataSorter sort, out int count, string arax)
        {

            var ret = GetCustomers(start, limit, out count, arax);

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "user_kod" : sort.Property;

            // filtreleme
            if (!string.IsNullOrEmpty(orderBy) && arax.Trim() != "")
            {
                switch (orderBy)
                {
                    case "user_kod":
                        ret = ret.Where(x => x.user_kod.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "user_ad":
                        ret = ret.Where(x => x.user_ad.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "user_soyad":
                        ret = ret.Where(x => x.user_soyad.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                }
            }

            var dynamicPropFromStr = typeof(UserRes).GetProperty(orderBy);

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