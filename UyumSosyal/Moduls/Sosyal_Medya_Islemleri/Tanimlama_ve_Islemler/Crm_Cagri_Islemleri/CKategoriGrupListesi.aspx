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
            HttpRuntime.Cache["CariKategori"] = (CariKategori[]) HttpRuntime.Cache["CariKategori"] == null ? Helper.GetWebService().GetCKategoriListesi("").Value.CariKategori : (CariKategori[]) HttpRuntime.Cache["CariKategori"];
            StoreCariKategori.DataSource = HttpRuntime.Cache["CariKategori"];
        }
    }
</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Cari Kategori</title>
</head>
<body>
<form runat="server">
    <ext:ResourceManager runat="server" />
    <ext:GridPanel
        ID="GridPanelCariKategori"
        runat="server" Height="310">
         <Store>
             <ext:Store ID="StoreCariKategori" runat="server">
                 <Model>
                     <ext:Model runat="server">
                         <Fields>
                             <ext:ModelField Name="kategori_kod" />
                             <ext:ModelField Name="kategori_ad" />
                             <ext:ModelField Name="grup" Type="Boolean"/>
                             <ext:ModelField Name="ckat_grup_kod" />
                             <ext:ModelField Name="cagri_gorunmesin" Type="Boolean"/>
                             <ext:ModelField Name="mobilcrm_gorunmesin" Type="Boolean" />
                             <ext:ModelField Name="ckarta_eklenemez" Type="Boolean" />
                             <ext:ModelField Name="ckatId" Type="Int" />
                         </Fields>
                     </ext:Model>
                 </Model>
             </ext:Store>
         </Store>
         <ColumnModel>
             <Columns>
                 <ext:Column runat="server" Text="Kod" DataIndex="kategori_kod" Width="130"/>
                 <ext:Column runat="server" Text="Ad" DataIndex="kategori_ad" Width="230"/>
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