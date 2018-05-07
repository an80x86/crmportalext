using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared
{
    [Serializable]
    public class ModulRes : BaseRes
    {
        public string modul_kod { get; set; }

        public string modul_path { get; set; }

        public bool durum { get; set; }

        public string aciklama { get; set; }
    }
}