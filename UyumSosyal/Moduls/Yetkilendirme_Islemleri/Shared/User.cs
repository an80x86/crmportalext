using System;
using System.Collections.Generic;
using System.Linq;
using Ext.Net;
using UyumSosyal.WebReference;
using System.Net;
using System.Configuration;
using System.Data;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Web.Caching;
using System.Web.Services;
using System.Web;
using Ext.Net.Utilities;
using UserRes = UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.Dto.UserRes;

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

        private static List<Dto.UserRes> GetData(out int count)
        {
            var liste = Helper.GetWebService().PortalUserList("", Helper.MIN, Helper.MAX);
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            count = liste.Value.KullaniciListesi.Length;// totalcount;
            var ret = new List<Dto.UserRes>(liste.Value.KullaniciListesi.Length/*liste.Value.totalcount*/);
            ret.AddRange(liste.Value.KullaniciListesi.Select(l => new Dto.UserRes()
            {
                durum = l.durum ? "aktif" : "pasif",
                id = l.id,
                user_ad = l.user_ad,
                user_kod = l.user_kod,
                user_sifre = l.user_sifre,
                user_soyad = l.user_soyad,
                _count = liste.Value.KullaniciListesi.Length//liste.Value.totalcount
            }));

            return ret;
        }

        private static List<Dto.UserRes> CutList(IReadOnlyList<UserRes> cache, int start, int limit)
        {
            var ret = new List<Dto.UserRes>();
            var count = cache.Count;
            for (var i = 0; i < count; i++)
            {
                if (i >= start && ret.Count < limit)
                {
                    ret.Add(cache[i]);
                }
            }
            return ret;
        }

        private static List<Dto.UserRes> FilterList(IEnumerable<UserRes> cache, string ara)
        {
            var ret = cache.Where(
                e => e.user_ad.ToLower().Contains(ara.ToLower()) ||
                     e.user_kod.ToLower().Contains(ara.ToLower()) ||
                     e.user_soyad.ToLower().Contains(ara.ToLower()) ||
                     e.durum.ToLower().Contains(ara.ToLower())
            );

            return ret.ToList();
        }

        private static List<Dto.UserRes> LoadData(out int count)
        {
            var cache = GetData(out count);

            HttpRuntime.Cache.Insert(
                "UserRes",
                cache,
                null,
                DateTime.Now.AddHours(ConfigurationManager.AppSettings["cachetime"].ToInt()),
                System.Web.Caching.Cache.NoSlidingExpiration
            );

            HttpRuntime.Cache.Insert(
                "UserResCount",
                count,
                null,
                DateTime.Now.AddHours(ConfigurationManager.AppSettings["cachetime"].ToInt()),
                System.Web.Caching.Cache.NoSlidingExpiration
            );

            return cache;
        }

        private static List<Dto.UserRes> GetCustomers(int start, int limit, out int count, string ara)
        {
            var cache = (List<Dto.UserRes>)HttpRuntime.Cache["UserRes"];
            var _count = HttpRuntime.Cache["UserResCount"] == null ? 0 : (int)HttpRuntime.Cache["UserResCount"];
            if (cache == null)
            {
                cache = LoadData(out count);

                if (ara.Trim().Length > 0) cache = FilterList(cache, ara);
                count = cache == null ? 0 : cache.Count;

                if (cache.Count < start) { start = 0; } // fixleme önemli!
                var ret = CutList(cache, start, limit);
                return ret;
            }
            else
            {
                //count = (int)_count;

                if (ara.Trim().Length>0 ) cache = FilterList(cache, ara);
                count = cache == null ? 0 : cache.Count;

                if (cache.Count < start) {start = 0;} // fixleme önemli!
                var ret = CutList(cache, start, limit);
                return ret;
            }
        }

        private static void ReLoad()
        {
            int count;
            LoadData(out count);
        }

        public static List<Dto.UserRes> GetFilter(int start, int limit, DataSorter sort, out int count, string ara)
        {
            var ret = GetCustomers(start, limit, out count, ara);

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "user_kod" : sort.Property;
            
            var dynamicPropFromStr = typeof(Dto.UserRes).GetProperty(orderBy);

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