<%@ Page Language="C#" %>

<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="UyumSosyal" %>
<%@ Import Namespace="UyumSosyal.WebReference" %>
<%@ Import Namespace="Newtonsoft.Json.Linq" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            HttpRuntime.Cache["Ilce"] = (Ilce[]) HttpRuntime.Cache["Ilce"] == null ? Helper.GetWebService().GenelIlceListesi("").Value : (Ilce[]) HttpRuntime.Cache["Ilce"];
            StoreIlce.DataSource = HttpRuntime.Cache["Ilce"];
        }
    }
</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
</head>
<body>
<form runat="server">
    <ext:ResourceManager runat="server" />

    <ext:GridPanel
        ID="GridPanelIlce"
        runat="server">
        <Store>
            <ext:Store ID="StoreIlce" runat="server">
                <Model>
                    <ext:Model runat="server">
                        <Fields>
                            <ext:ModelField Name="sehir_ad" />
                            <ext:ModelField Name="ilce_ad" />
                            <ext:ModelField Name="okod1" />
                            <ext:ModelField Name="okod2" />
                            <ext:ModelField Name="bolge_kod" />
                            <ext:ModelField Name="ilceId" Type="Int" />
                        </Fields>
                    </ext:Model>
                </Model>
            </ext:Store>
        </Store>
        <ColumnModel>
            <Columns>
                <ext:Column runat="server" Text="İlçe" DataIndex="ilce_ad" Width="230"/>
            </Columns>
        </ColumnModel>
        <Plugins>
            <ext:FilterHeader runat="server" />
        </Plugins>
        <SelectionModel>
            <ext:RowSelectionModel runat="server" />
        </SelectionModel>
    </ext:GridPanel>   
    
</form>
</body>
</html>