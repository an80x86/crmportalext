using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared
{
    public class FormFirsatRes
    {
        public string firsat_kod {get;set;}

        public string firsat_Ad {get;set;}

        public string cari_kod {get;set;}

        public string cari_ad {get;set;}

        public string firsat_tarih {get;set;}

        public string firsat_statu {get;set;}

        public string firsati_takip_eden {get;set;}

        public int _count { get; set; }

        public int id { get; set; }
    }
}