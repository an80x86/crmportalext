using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.Dto
{
    [Serializable]
    public class PortalYetkiRes : BaseRes
    {
        public bool is_okuma {get;set;}

        public bool is_yazma {get;set;}

        public bool is_silme {get;set;}

        public bool is_olusturma {get;set;}

        public int aspnet_modul_id {get;set;}

        public int aspnet_rol_id {get;set;}
    }
}