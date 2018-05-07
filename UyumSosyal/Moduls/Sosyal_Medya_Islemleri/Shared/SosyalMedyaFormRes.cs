using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UyumSosyal.Moduls.Sosyal_Medya_Islemleri.Shared
{
    public class SosyalMedyaFormRes : BaseRes
    {
        public string form_id { get; set; }

        public string form_ad { get; set; }

        public bool pasif { get; set; }

        public string form_tip { get; set; } // facebook ve instagram
    }

}