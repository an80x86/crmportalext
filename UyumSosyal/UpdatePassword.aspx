<%@ Page Language="C#" UICulture="tr-TR" %>
<%@ Import Namespace="UyumSosyal" %>
<%@ Import Namespace="Ext.Net.Utilities" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    { 
        if (Session["user"] == null)
        {
            Response.Redirect("Login.aspx");
            return;
        }
    }

    public static bool UserCheck(string userName, string userPass1, string userPass2)
    {
        var ret = false;

        if (userPass1 == "1" || userPass2 == "1" || userPass1.Trim() == "" || userPass2.Trim() == "" || (userPass1 != userPass2))
        {
            throw new Exception("Şifre boş yada bir olamaz!");
        }

        var liste = Helper.GetWebService().PortalUserList(userName, 0, 100);
        if (!string.IsNullOrEmpty(liste.Message))
        {
            throw new Exception(liste.Message);
        }

        if (liste.Value.KullaniciListesi.Length < 1)
        {
            throw new Exception("Kullanıcı Uyum'da bulunamadı!");
        }

        var x0 = new UyumSosyal.WebReference.UserRes[1];
        var update = liste.Value.KullaniciListesi[0];
        update.user_sifre = userPass1.Md5Hash();
        x0[0] = update;
        var sonuc = Helper.GetWebService().InsertPortalUSer(x0);
        ret = sonuc.Result;

        if (!ret)
        {
            throw new Exception(sonuc.Message);
        }

        return ret;
    }

    protected void btnLogin_Click(object sender, DirectEventArgs e)
    {
        var passCheck = UserCheck((string)Session["user"], this.txtPassword1.Text, this.txtPassword2.Text);
        if (passCheck)
        {
            Response.Redirect("Default.aspx");
            return;
        }

        this.txtPassword1.Text = "";
        this.txtPassword2.Text = "";
        X.Msg.Show(new MessageBoxConfig
        {
            Title = "Dikkat",
            Message = "Şifre değiştirme işlemi başarısız!",
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
        var onKeyDown = function(field, e) {
            if (e.getKey() == e.ENTER) {
                e.stopEvent();
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
                    Title="Kullanıcı Şifre Değiştirme"
                    Width="400"
                    Frame="true"
                    BodyPadding="13"
                    DefaultAnchor="100%">
                    <Items>
                        <ext:TextField
                            ID="txtPassword1"
                            runat="server"
                            EnableKeyEvents="true"
                            AllowBlank="false"
                            FieldLabel="Şifre"
                            Name="pass1"
                            EmptyText="Şifre giriniz"
                            InputType="Password">
                            <Listeners>
                                <KeyDown Fn="onKeyDown"/>
                            </Listeners>
                        </ext:TextField>

                        <ext:TextField
                            ID="txtPassword2"
                            runat="server"
                            EnableKeyEvents="true"
                            AllowBlank="false"
                            FieldLabel="Tekrar Şifre"
                            Name="pass2"
                            EmptyText="Şifre giriniz"
                            InputType="Password">
                            <Listeners>
                                <KeyDown Fn="onKeyDown"/>
                            </Listeners>
                        </ext:TextField>
                    </Items>
                    <Buttons>
                        <ext:Button ID="btnLogin" runat="server" Text="Şifre Değiştir" Icon="Accept">
                            <Listeners>
                                <Click Handler="
                                    if (#{txtPassword1}.getValue() === '1') {
                                        Ext.Msg.alert('Error','Şifre 1 olamaz!');
                                        return false;
                                    }
                                    if (#{txtPassword2}.getValue() === '1') {
                                        Ext.Msg.alert('Error','Tekrar şifre 1 olamaz!');
                                        return false;
                                    }
                                    if (!#{txtPassword1}.validate() || !#{txtPassword2}.validate()) {
                                        Ext.Msg.alert('Error','Şifreler boş geçilemez!');
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
                                <Click Handler="#{txtPassword1}.setValue('');#{txtPassword2}.setValue('');" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </Items>
    </ext:Viewport>
</body>
</html>