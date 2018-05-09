//#define WST

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Threading;
using System.Globalization;
using Ext.Net;
using UyumSosyal.WebReference;


namespace UyumSosyal
{
    public class ExtNetVersion
    {
        public static Version Version = typeof(UyumSosyal.Global).Assembly.GetName().Version;

        private static string rev = (Version.Revision == 0) ? "" : ("." + Version.Revision);
        private static string bld = (Version.Build == 0) ? "" : ("." + Version.Build + rev);

        public static string Major = Version.Major + "." + Version.Minor + bld;
        public static string WithBuild = Version.Major + "." + Version.Minor + "." + Version.Build;
        public static string Full = Version.ToString();
    }

    public class WebServiceTest
    {
        public static void Sehir()
        {
            var ret = Helper.GetWebService().GenelSehirListesi("");

        }

        public static void Ilce()
        {
            var ret = Helper.GetWebService().GenelIlceListesi("");

        }

        public static void Ulke()
        {
            var ret = Helper.GetWebService().UlkeListesi("");

        }
        public static void UnvanGrup()
        {
            var ret = Helper.GetWebService().UnvanGrupListesi("", "");

        }

        public static void Unvan()
        {
            var ret = Helper.GetWebService().UnvanListesi2("", "");

        }

        public static void Cagri()
        {
            var ret = Helper.GetWebService().CagriListesi("", DateTime.Parse("2018-04-01"), DateTime.Parse("2018-05-09"), "");

            Helper.GetWebService().CagriKaydet(new Cagri()
            {

            });
        }
    }

    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
#if WST
            WebServiceTest.Sehir();
            WebServiceTest.Ilce();
            WebServiceTest.Ulke();
            WebServiceTest.UnvanGrup();
            WebServiceTest.Unvan();
            WebServiceTest.Cagri();
#endif

            if (!Ext.Net.ResourceManager.HasFactory("mybutton"))
            {
                Ext.Net.ResourceManager.AddFactory(delegate
                {
                    var b = new Ext.Net.Button
                    {
                        Text = "Factory button",
                        Handler = "Ext.Msg.alert('Factory button', 'The button is clicked');",
                        Plugins =
                    {
                        new Badge
                        {
                            Text = "20"
                        }
                    },

                        Factory = new FactoryConfig
                        {
                            Alias = "mybutton",
                            Instance = "My.Button"
                        }
                    };

                    return b;
                }, "mybutton", "My.Button");
            }

            if (!Ext.Net.ResourceManager.HasFactory("mywindow"))
            {
                Ext.Net.ResourceManager.AddFactory("~/Examples/Miscellaneous/Factory/Basic/MyWindow.ascx", "mywindow", "My.Window");
            }
        }

        protected void Session_Start(object sender, EventArgs e)
        {
#if DEBUG
            // Enables debugging code output by default if the project is built in debug configuration.
            if (Session["Ext.Net.ScriptMode"] == null)
            {
                Session["Ext.Net.ScriptMode"] = ScriptMode.Debug;
            }

            if (Session["Ext.Net.SourceFormatting"] == null)
            {
                Session["Ext.Net.SourceFormatting"] = true;
            }
#endif // DEBUG
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AcquireRequestState(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}