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

namespace UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared
{
    public class CrmForm
    {
        public static List<CrmFormRes> GetFilter(int start, int limit, DataSorter sort, out int count, string arax, DateTime bas, DateTime bit)
        {
            // saçmalıyır...
            var liste = Helper.GetWebService().CrmFormListesi(bas, bit, 0, 10000);// start, limit);
            //var liste = Helper.GetWebService().CrmFormListesi(DateTime.Now.AddYears(-10) , DateTime.Now.AddYears(10), 0, 10000);// start, limit);

            if (!string.IsNullOrEmpty(liste.Message))
            {
                throw new Exception(liste.Message);
            }

            var id = 0;
            count = liste.Value.FormListesi.Length;
            var tmpCount = liste.Value.FormListesi.Length;
            var ret = new List<CrmFormRes>(tmpCount);
            ret.AddRange(liste.Value.FormListesi.Select(l => new CrmFormRes()
            {
                id = (id++),
                _count = tmpCount,
                form_ad = l.form_ad,
                tip = l.tip,
                yetkili_kisi = l.yetkili_kisi,
                firma_tel = l.firma_tel,
                firma_email = l.firma_email,
                aciklama = l.aciklama,
                firma_web = l.firma_web,
                cari_kod = l.cari_kod,
                cari_ad = l.cari_ad,
                geldigi_kanal = l.geldigi_kanal,
                kapali = l.kapali != false ? "Kapali" : "Acik",
                master_no = l.master_no,
                faaliyet_yili = l.faaliyet_yili,
                faaliyet_yili2 = l.faaliyet_yili.JaponDate(),
                create_date = l.create_date.ToString("dd.MM.yyyy"),
                create_date2 = l.create_date.ToString("yyyy-MM-dd")

            }));//.Where(x=> !string.IsNullOrEmpty(x.form_ad) && !string.IsNullOrEmpty(x.tip)));

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "geldigi_kanal" : sort.Property;

            // filtreleme
            if (!string.IsNullOrEmpty(orderBy) && arax.Trim() != "")
            {
                switch (orderBy)
                {
                    case "create_date":
                        ret = ret.Where(x => x.create_date2.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "faaliyet_yili":
                        ret = ret.Where(x => x.faaliyet_yili2.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "kapali":
                        ret = ret.Where(x => x.kapali.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "form_ad":
                        ret = ret.Where(x => x.form_ad.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "tip":
                        ret = ret.Where(x => x.tip.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "yetkili_kisi":
                        ret = ret.Where(x => x.yetkili_kisi.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "firma_tel":
                        ret = ret.Where(x => x.firma_tel.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "firma_email":
                        ret = ret.Where(x => x.firma_email.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "aciklama":
                        ret = ret.Where(x => x.aciklama.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "firma_web":
                        ret = ret.Where(x => x.firma_web.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "cari_kod":
                        ret = ret.Where(x => x.cari_kod.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "cari_ad":
                        ret = ret.Where(x => x.cari_ad.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "geldigi_kanal":
                        ret = ret.Where(x => x.geldigi_kanal.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                }
            }

            var dynamicPropFromStr = typeof(CrmFormRes).GetProperty(orderBy);
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

        public static List<FormFirsatRes> GetFilterFirsat(int start, int limit, DataSorter sort, out int count, string arax)
        {
            count = 0;
            if (HttpContext.Current.Session["secilenCrmFormIslemleri"] == null) return new List<FormFirsatRes>(); // otomatik her seferinde geliyor, diğer methodlara da ekle sunucuyu meşgul etmesin.

            var mId = HttpContext.Current.Session["secilenCrmFormIslemleri"] == null ? "0" : HttpContext.Current.Session["secilenCrmFormIslemleri"].ToString();
            var liste = Helper.GetWebService().CrmFormFirsatCagriListesi(mId.ToInt());

            var id = 0;
            count = liste.Value.firsatlist.Length;
            var ret = new List<FormFirsatRes>();
            foreach (var firsat in liste.Value.firsatlist)
            {
                ret.Add(new FormFirsatRes()
                {
                    id = (id++),
                    _count = count,
                    firsat_statu = firsat.firsat_statu,
                    cari_ad = firsat.cari_ad,
                    cari_kod = firsat.cari_kod,
                    firsat_Ad = firsat.firsat_Ad,
                    firsat_kod = firsat.firsat_kod,
                    firsat_tarih = firsat.firsat_tarih,
                    firsati_takip_eden = firsat.firsati_takip_eden
                });
            }

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "cari_kod" : sort.Property;

            // filtreleme
            if (!string.IsNullOrEmpty(orderBy) && arax.Trim() != "")
            {
                switch (orderBy)
                {
                    case "firsat_statu":
                        ret = ret.Where(x => x.firsat_statu.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "cari_ad":
                        ret = ret.Where(x => x.cari_ad.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "cari_kod":
                        ret = ret.Where(x => x.cari_kod.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "firsat_Ad":
                        ret = ret.Where(x => x.firsat_Ad.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "firsat_kod":
                        ret = ret.Where(x => x.firsat_kod.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "firsat_tarih":
                        ret = ret.Where(x => x.firsat_tarih.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "firsati_takip_eden":
                        ret = ret.Where(x => x.firsati_takip_eden.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                }
            }

            var dynamicPropFromStr = typeof(FormFirsatRes).GetProperty(orderBy);
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

        public static List<FormCagriRes> GetFilterCagri(int start, int limit, DataSorter sort, out int count, string arax)
        {
            count = 0;
            if (HttpContext.Current.Session["secilenCrmFormIslemleri"] == null) return new List<FormCagriRes>(); // otomatik her seferinde geliyor, diğer methodlara da ekle sunucuyu meşgul etmesin.

            var mId = HttpContext.Current.Session["secilenCrmFormIslemleri"] == null ? "0" : HttpContext.Current.Session["secilenCrmFormIslemleri"].ToString();
            var liste = Helper.GetWebService().CrmFormFirsatCagriListesi(mId.ToInt());

            var id = 0;
            count = liste.Value.cagrilist.Length;
            var ret = new List<FormCagriRes>();
            foreach (var cagri in liste.Value.cagrilist)
            {
                ret.Add(new FormCagriRes()
                {
                    id = (id++),
                    _count = count,
                    cari_kod = cagri.cari_kod,
                    aciklama1 = cagri.aciklama1,
                    belge_tarih = cagri.belge_tarih,
                    cagri_konusu = cagri.cagri_konusu
                });
            }

            var orderBy = String.IsNullOrEmpty(sort.Property) ? "cari_kod" : sort.Property;

            // filtreleme
            if (!string.IsNullOrEmpty(orderBy) && arax.Trim() != "")
            {
                switch (orderBy)
                {
                    case "cari_kod":
                        ret = ret.Where(x => x.cari_kod.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "aciklama1":
                        ret = ret.Where(x => x.aciklama1.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "belge_tarih":
                        ret = ret.Where(x => x.belge_tarih.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                    case "cagri_konusu":
                        ret = ret.Where(x => x.cagri_konusu.ToLower().Contains(arax.ToLower())).ToList();
                        count = ret.Count;
                        break;
                }
            }

            var dynamicPropFromStr = typeof(FormCagriRes).GetProperty(orderBy);
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

        public static List<FirsatFaaliyetRes> GetFilterFirsatFaaliyet(int start, int limit)
        {
            if (HttpContext.Current.Session["secilenCrmFormIslemleriFirsat"] == null) return new List<FirsatFaaliyetRes>(); // otomatik her seferinde geliyor, diğer methodlara da ekle sunucuyu meşgul etmesin.

            var mId = HttpContext.Current.Session["secilenCrmFormIslemleriFirsat"] == null ? "0" : HttpContext.Current.Session["secilenCrmFormIslemleriFirsat"].ToString();
            var liste = Helper.GetWebService().FirsatFaaliyetListesi(mId);

            var id = 0;
            var ret = new List<FirsatFaaliyetRes>();
            foreach (var l in liste.Value)
            {
                ret.Add(new FirsatFaaliyetRes()
                {
                    id = (id++),
                    _count = liste.Value.Length,
                    aciklama = l.aciklama,
                    faaliyet_tarih = l.faaliyet_tarih,
                    iliski_tur = l.iliski_tur,
                    kullanici = l.kullanici,
                    musteri = l.musteri,
                    musteri_ad = l.musteri_ad
                });
            }

            return ret;
        }
    }
}