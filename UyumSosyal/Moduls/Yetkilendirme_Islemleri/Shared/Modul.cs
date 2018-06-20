using System;
using System.Collections.Generic;
using System.Linq;
using Ext.Net;
using UyumSosyal.WebReference;
using System.Net;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Web;
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

            ReLoad();
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

            ReLoad();
            return "ok";
        }

        private static List<Dto.ModulRes> GetData(out int count)
        {
            var liste = Helper.GetWebService().PortalModulList("", Helper.MIN, Helper.MAX);
            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            count = liste.Value.ModulListesi.Length;// totalcount;
            var ret = new List<Dto.ModulRes>(liste.Value.ModulListesi.Length/*liste.Value.totalcount*/);
            ret.AddRange(liste.Value.ModulListesi.Select(l => new Dto.ModulRes()
            {
                aciklama = l.aciklama,
                durum = l.durum ? "aktif" : "pasif",
                id = l.id,
                modul_kod = l.modul_kod,
                modul_path = l.modul_path,
                _count = liste.Value.totalcount//liste.Value.totalcount
            }));

            return ret;
        }

        private static List<Dto.ModulRes> CutList(IReadOnlyList<Dto.ModulRes> cache, int start, int limit)
        {
            var ret = new List<Dto.ModulRes>();
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

        private static List<Dto.ModulRes> FilterList(IEnumerable<Dto.ModulRes> cache, string ara)
        {
            var ret = cache.Where(
                e => e.modul_kod.ToLower().Contains(ara.ToLower()) ||
                     e.modul_path.ToLower().Contains(ara.ToLower()) ||
                     e.aciklama.ToLower().Contains(ara.ToLower())
            );

            return ret.ToList();
        }

        private static List<Dto.ModulRes> LoadData(out int count)
        {
            var cache = GetData(out count);

            HttpRuntime.Cache.Insert(
                "ModulRes",
                cache,
                null,
                DateTime.Now.AddHours(ConfigurationManager.AppSettings["cachetime"].ToInt()),
                System.Web.Caching.Cache.NoSlidingExpiration
            );

            HttpRuntime.Cache.Insert(
                "ModulResCount",
                count,
                null,
                DateTime.Now.AddHours(ConfigurationManager.AppSettings["cachetime"].ToInt()),
                System.Web.Caching.Cache.NoSlidingExpiration
            );

            return cache;
        }

        private static List<Dto.ModulRes> GetCustomers(int start, int limit, out int count, string ara)
        {

            var cache = (List<Dto.ModulRes>)HttpRuntime.Cache["ModulRes"];
            var _count = HttpRuntime.Cache["ModulResCount"] == null ? 0 : (int)HttpRuntime.Cache["ModulResCount"];
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

                if (ara.Trim().Length > 0) cache = FilterList(cache, ara);
                count = cache == null ? 0 : cache.Count;

                if (cache.Count < start) { start = 0; } // fixleme önemli!
                var ret = CutList(cache, start, limit);
                return ret;
            }

            return null;
        }

        private static List<Dto.ModulRes> GetCustomers(out int count, string ara)
        {

            var cache = (List<Dto.ModulRes>)HttpRuntime.Cache["ModulRes"];
            var _count = HttpRuntime.Cache["ModulResCount"] == null ? 0 : (int)HttpRuntime.Cache["ModulResCount"];
            if (cache == null)
            {
                cache = LoadData(out count);

                if (ara.Trim().Length > 0) cache = FilterList(cache, ara);
                count = cache == null ? 0 : cache.Count;

                return cache;
            }
            else
            {
                //count = (int)_count;

                if (ara.Trim().Length > 0) cache = FilterList(cache, ara);
                count = cache == null ? 0 : cache.Count;

                return cache;
            }
        }

        private static void ReLoad()
        {
            int count;
            LoadData(out count);
        }

        public static List<Dto.ModulRes> GetFilter(int start, int limit, DataSorter sort, out int count, string ara)
        {
            var ret = GetCustomers(out count, ara);

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "modul_kod" : sort.Property;

            var dynamicPropFromStr = typeof(Dto.ModulRes).GetProperty(orderBy);

            if (sort.Direction == SortDirection.ASC)
            {
                ret = ret.OrderBy(x => dynamicPropFromStr.GetValue(x, null)).ToList();
            }
            else
            {
                ret = ret.OrderByDescending(x => dynamicPropFromStr.GetValue(x, null)).ToList();
            }

            if (ret.Count < start) { start = 0; } // fixleme önemli!
            count = ret.Count;
            ret = CutList(ret, start, limit);

            return ret;
        }
    }
}