using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.Dto
{
    [Serializable]
    public class UserRolRes : BaseRes
    {
        public int aspnet_rol_id { get; set; }
        public string rol { get; set; }

        public int aspnet_kullanici_id { get; set; }
        public string kullanici { get; set; }
    }
}