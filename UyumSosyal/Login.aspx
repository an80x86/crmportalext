<%@ Page Language="C#" UICulture="tr-TR" %>
<%@ Import Namespace="UyumSosyal" %>

<script runat="server">
    public static bool UserCheck(string userName, string userPass)
    {
        var ret = false;
        try
        {
            var liste = Helper.GetWebService().PortalUserList(userName, Helper.MIN, Helper.MAX);
            if (!string.IsNullOrEmpty(liste.Message))
            {
                Helper.Error("Login işleminde hata : " + liste.Message);
                return false;
            }

            foreach (var kul in liste.Value.KullaniciListesi)
            {
                if (kul.user_sifre == userPass.Md5Hash())
                {
                    ret = true;
                    break;
                }
            }
        }
        catch(Exception ex)
        {
            Helper.Error("PortalUserList'de web service hatası : " + ex.Message);
        }

        return ret;
    }

    protected void btnLogin_Click(object sender, DirectEventArgs e)
    {
        var userCheck = UserCheck(this.txtUsername.Text, this.txtPassword.Text);
        if (userCheck)
        {
            Session["user"] = this.txtUsername.Text;
            Response.Redirect(this.txtPassword.Text == "1" ? "UpdatePassword.aspx" : "Default.aspx");
            return;
        }

        this.txtPassword.Text = "";
        X.Msg.Show(new MessageBoxConfig
        {
            Title = "Dikkat",
            Message = "Kullanıcı veya Şifre hatalı!",
            Buttons = MessageBox.Button.OK,
            Icon = MessageBox.Icon.ERROR,
            AnimEl = this.btnLogin.ClientID
        });
    }
</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>UyumSosyal v1.0</title>
    <link href="/resources/css/examples.css" rel="stylesheet" />
    <script type="text/javascript">
        Ext.onReady(function() {
            Ext.getCmp('txtUsername').focus();
        });
        var onKeyDown1 = function (field, e) {
            if (e.getKey() === e.ENTER) {
                e.stopEvent();
                Ext.getCmp('txtPassword').focus();
            }
        }
        var onKeyDown2 = function (field, e) {
            if (e.getKey() === e.ENTER) {
                e.stopEvent();
                Ext.getCmp('btnLogin').focus();
            }
        }
    </script>
</head>
<body>
    <ext:ResourceManager ID="ResourceManager1" runat="server" />
    
    <ext:Viewport runat="server">
        <LayoutConfig>
            <ext:VBoxLayoutConfig Align="Center" Pack="Center" />
        </LayoutConfig>
        <Items>
            <ext:FormPanel
                    runat="server"
                    Title="Kullanıcı Girişi"
                    Width="400"
                    Frame="true"
                    BodyPadding="13"
                    DefaultAnchor="100%">
                    <Items>
                        <ext:TextField
                            ID="txtUsername"
                            runat="server"
                            EnableKeyEvents="true"
                            AllowBlank="false"
                            FieldLabel="Kullanıcı Adı"
                            Name="user"
                            EmptyText="Kullanıcı adı giriniz">
                            <Listeners>
                                <KeyDown Fn="onKeyDown1"/>
                            </Listeners>
                        </ext:TextField>

                        <ext:TextField
                            ID="txtPassword"
                            runat="server"
                            EnableKeyEvents="true"
                            AllowBlank="false"
                            FieldLabel="Şifre"
                            Name="pass"
                            EmptyText="Şifre giriniz"
                            InputType="Password">
                            <Listeners>
                                <KeyDown Fn="onKeyDown2"/>
                            </Listeners>
                        </ext:TextField>
                    </Items>
                    <Buttons>
                        <ext:Button ID="btnLogin" runat="server" Text="Giriş" Icon="Accept">
                            <Listeners>
                                <Click Handler="
                                    if (!#{txtUsername}.validate() || !#{txtPassword}.validate()) {
                                        Ext.Msg.alert('Error','Kullanıcı adı ve şifre boş geçilemez!');
                                        return false;
                                    }" />
                            </Listeners>
                            <DirectEvents>
                                <Click OnEvent="btnLogin_Click">
                                    <EventMask ShowMask="true" Msg="Kontrol ediliyor..." MinDelay="500" />
                                </Click>
                            </DirectEvents>
                        </ext:Button>
                        <ext:Button ID="btnCancel" runat="server" Text="Temizle" Icon="Decline">
                            <Listeners>
                                <Click Handler="#{txtUsername}.setValue('');#{txtPassword}.setValue('');" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </Items>
    </ext:Viewport>
</body>
</html>