using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared
{
    public class UrunSariAlanListesiRes
    {
        public int id { get; set; }
        public string code { get; set; }
        public string desc { get; set; }
        public int master_no { get; set; }
        public int _count { get; set; }
    }
}