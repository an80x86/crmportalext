using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared
{
    public class FirsatFaaliyetRes
    {
        public string faaliyet_tarih {get;set;}
        public string musteri {get;set;}
        public string musteri_ad {get;set;}
        public string iliski_tur {get;set;}
        public string aciklama {get;set;}
        public string kullanici {get;set;}
        public int id { get; set; }
        public int _count { get; set; }
    }
}