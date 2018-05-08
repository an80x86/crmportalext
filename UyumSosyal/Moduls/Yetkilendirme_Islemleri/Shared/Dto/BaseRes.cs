using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.Dto
{
    [Serializable]
    public class BaseRes
    {
        public int id { get; set; }
        public int _count { get; set; }
    }
}