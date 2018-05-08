using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.Dto
{
    [Serializable]
    public class UserRes : BaseRes
    {
        public string user_kod { get; set; }

        public string user_ad { get; set; }

        public string user_soyad { get; set; }

        public string user_sifre { get; set; }

        public string durum { get; set; }
    }

}