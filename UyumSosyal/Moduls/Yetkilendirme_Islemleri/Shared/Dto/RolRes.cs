using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.Dto
{
    public class RolRes : BaseRes
    {
        public string rol_kod { get; set; }

        public string aciklama { get; set; }
    }
}