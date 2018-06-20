using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.Dto
{
    [Serializable]
    public class PortalYetkiRes : BaseRes
    {
        public string is_okuma {get;set;}

        public string is_yazma {get;set;}

        public string is_silme {get;set;}

        public string is_olusturma {get;set;}

        public int aspnet_modul_id {get;set;}
        public string modul_kod { get; set; }

        public int aspnet_rol_id {get;set;}
        public string rol_kod { get; set; }
    }
}