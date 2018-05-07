using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared
{
    public class HedefKitleMRes : BaseRes
    {
        public string hedef_liste_id {get;set;}

        public string hedef_liste_ad {get;set;}

        public string telefon_mail {get;set;}

        public string aciklama {get;set;}
    }
}