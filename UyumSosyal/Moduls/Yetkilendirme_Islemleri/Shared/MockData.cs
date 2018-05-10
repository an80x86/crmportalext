using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.Dto;

namespace UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared
{
    public class MockData
    {
        public List<UserRes> userRes {
            get
            {
                var ret = new List<UserRes>();
                ret.Add(new UserRes
                {
                    id = 1,
                    user_kod = "admin",
                    user_ad = "Yönetici",
                    user_soyad = "Kullanıcı",
                    user_sifre = "c81e728d9d4c2f636f067f89cc14862c",
                    durum = "aktif"
                });
                ret.Add(new UserRes
                {
                    id = 2,
                    user_kod = "user",
                    user_ad = "Normal",
                    user_soyad = "Kullanıcı",
                    user_sifre = "c81e728d9d4c2f636f067f89cc14862c",
                    durum = "aktif"
                });
                ret.Add(new UserRes
                {
                    id = 3,
                    user_kod = "rapor",
                    user_ad = "Rapor",
                    user_soyad = "Kullanıcı",
                    user_sifre = "c81e728d9d4c2f636f067f89cc14862c",
                    durum = "aktif"
                });

                foreach(var r in ret)
                {
                    r._count = ret.Count;
                }

                return ret;
            }
        }

        public List<UserRolRes> userRolRes
        {
            get
            {
                var ret = new List<UserRolRes>();
                ret.Add(new UserRolRes
                {
                    
                });

                foreach (var r in ret)
                {
                    r._count = ret.Count;
                }

                return new List<UserRolRes>();
            }
        }

        public List<ModulRes> modulRes
        {
            get
            {
                var ret = new List<ModulRes>();
                ret.Add(new ModulRes()
                {
                    id = 1,
                    modul_kod = "kullanici",
                    modul_path = "",
                    aciklama = "Kullanıcı İşlemleri",
                    durum = "aktif",
                });
                ret.Add(new ModulRes()
                {
                    id = 2,
                    modul_kod = "modul",
                    modul_path = "",
                    aciklama = "Modül İşlemleri",
                    durum = "aktif",
                });
                ret.Add(new ModulRes()
                {
                    id = 3,
                    modul_kod = "rol",
                    modul_path = "",
                    aciklama = "Rol İşlemleri",
                    durum = "aktif",
                });
                ret.Add(new ModulRes()
                {
                    id = 4,
                    modul_kod = "yetki",
                    modul_path = "",
                    aciklama = "Yetki İşlemleri",
                    durum = "aktif",
                });
                ret.Add(new ModulRes()
                {
                    id = 5,
                    modul_kod = "form",
                    modul_path = "",
                    aciklama = "Form İşlemleri",
                    durum = "aktif",
                });
                ret.Add(new ModulRes()
                {
                    id = 6,
                    modul_kod = "detay",
                    modul_path = "",
                    aciklama = "Form Detay İşlemleri",
                    durum = "aktif",
                });

                foreach (var r in ret)
                {
                    r._count = ret.Count;
                }

                return new List<ModulRes>();
            }
        }

        public List<PortalYetkiRes> portalYetkiRes
        {
            get
            {
                var ret = new List<PortalYetkiRes>();
                ret.Add(new PortalYetkiRes()
                {
                    id = 1,
                    is_okuma = "evet",
                    is_olusturma = "evet",
                    is_silme = "evet",
                    is_yazma = "evet",
                    aspnet_modul_id = 1,
                    aspnet_rol_id = 0
                });

                foreach (var r in ret)
                {
                    r._count = ret.Count;
                }

                return ret;
            }
        }
    }
}