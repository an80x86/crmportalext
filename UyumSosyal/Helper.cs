﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared;
using UyumSosyal.WebReference;

namespace UyumSosyal
{
    using Ext.Net;
    using System;
    
    public static class Helper
    {
        public static int MIN = 0;
        public static int MAX = 99999;

        public static string Md5Hash(this string input)
        {
            var hash = new StringBuilder();
            var md5Provider = new MD5CryptoServiceProvider();
            var bytes = md5Provider.ComputeHash(new UTF8Encoding().GetBytes(input));

            foreach (var t in bytes)
            {
                hash.Append(t.ToString("x2"));
            }
            return hash.ToString();
        }

        public static int ToInt(this string str)
        {
            return int.Parse(str);
        }

        public static WsdlUyumCrm GetWebService()
        {
            var serv = new WsdlUyumCrm {CookieContainer = new CookieContainer(1000)};
            serv.UyumUserLogin(
                ConfigurationManager.AppSettings["val1"],
                ConfigurationManager.AppSettings["val2"],
                ConfigurationManager.AppSettings["val3"]
            );

            return serv;
        }

        public static void Error(string msg)
        {
            X.Msg.Alert("Dikkat", msg).Show();
        }

        public static void Error(string fnkName, string msg)
        {
            X.Msg.Alert("Dikkat", string.Format("Uyum web service'i cevap vermiyor yada hata oluştu : metod adı : {0}, sistemden gelen hatya mesajı : {1}",
                fnkName, msg)).Show();
        }
        public static void Error(string fnkName, Exception ex)
        {
            X.Msg.Alert("Dikkat", string.Format("Uyum web service'i de hata oluştu : metod adı : {0}, sistemden gelen hatya mesajı : {1}",
                fnkName, ex.Message)).Show();
        }
    }
}