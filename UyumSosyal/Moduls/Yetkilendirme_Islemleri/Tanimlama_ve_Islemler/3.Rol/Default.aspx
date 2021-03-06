﻿<%@ Page Language="C#" UICulture="tr-TR" %>
<%@ Import Namespace="UyumSosyal" %>

<script runat="server">
    StoreReadDataEventArgs e;
    
    protected void Store1_RefreshData(object sender, StoreReadDataEventArgs e)
    {
        this.e = e;
        this.Store1.DataBind();
    }

    protected void ObjectSelecting(object sender, ObjectDataSourceSelectingEventArgs e)
    {
        e.InputParameters["start"] = this.e.Start;
        e.InputParameters["limit"] = this.e.Limit;
        e.InputParameters["sort"] = this.e.Sort[0];
        e.InputParameters["arax"] = TextFieldArama.Text;
    }

    protected void ObjectDataSource1_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        (this.Store1.Proxy[0] as PageProxy).Total = (int)e.OutputParameters["count"];
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["user"] == null)
        {
            Response.Write("<script type='text/javascript'>");
            Response.Write("top.document.location.href='../../../../Login.aspx';");
            Response.Write("<" + "/" + "script>");
            Response.End();
            return;
        }

        var rols = UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.UserRol.GetRols();
        this.SelectBoxRol.GetStore().DataSource = rols; 

        var users = UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.UserRol.GetUsers();
        this.SelectBoxUser.GetStore().DataSource = users; 
    }

    protected void ButtonSave(object sender, DirectEventArgs e)
    {
        if (string.IsNullOrEmpty(SelectBoxRol.SelectedItem.Value))
        {
            X.Msg.Alert("Dikkat", "Lütfen Rol seçiniz!").Show();
            return;
        }

        if (string.IsNullOrEmpty(SelectBoxUser.SelectedItem.Value))
        {
            X.Msg.Alert("Dikkat", "Lütfen Kullanıcı seçiniz!").Show();
            return;
        }

        var err = UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.UserRol.Save(
            gizli.Value, // ekle ise boş düzelt ise dolu gelir
            SelectBoxRol.SelectedItem.Value,
            SelectBoxUser.SelectedItem.Value);
        if (err != "ok")
        {
            X.Msg.Alert("Dikkat", err).Show();
            return;
        }

        // tazele
        Store1.Reload();
        gizli.Value = "";
        SelectBoxRol.SelectedItem.Value = "";
        SelectBoxUser.SelectedItem.Value = "";
        PickWindowRolAdd.Hide();
    }

    [DirectMethod(Namespace = "CompanyX", Timeout = 300000)]
    public void Sil(string kkod)
    {
        try
        {
            var don = UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.UserRol.Remove(kkod.ToInt());
            X.MessageBox.Hide();
            if (don != "ok")
            {
                X.Msg.Alert("Dikkat", don).Show();
            }
            else
            {
                // tazele
                Store1.Reload();
                gizli.Value = "";
                lbUser.Text = "Seçilen Rol : Yok!";
            }
        }
        finally
        {
            X.MessageBox.Hide();
        }
    }        
</script>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title>Rol Tanimlari</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        var showResult = function (btn) {
            if (btn == 'Yes' || btn == 'yes' || btn == 'Evet' || btn == 'evet') {
                var v = Ext.getCmp('GridPanel1').getSelectionModel().getSelection();

                Ext.MessageBox.show({
                    msg: 'Islem yapilirken lutfen bekleyiniz.',
                    progressText: 'Bekleyiniz...',
                    width: 300,
                    wait: true,
                    waitConfig: { interval: 200 }
                });

                CompanyX.Sil(v[0].data.id);
            }
        };
        var keyHandler = function (k, e) {
            if (e.getKey() == 13) {
                Ext.getCmp('GridPanel1').getStore().load();
            }
        };
    </script> 

    <style type="text/css">
        .x-grid-cell-fullName .x-grid-cell-inner {
            font-family : tahoma, verdana;
            display     : block;
            font-weight : normal;
            font-style  : normal;
            color       : #385F95;
            white-space : normal;
        }
        
        .x-grid-rowbody div {
            margin : 2px 5px 20px 5px !important;
            width  : 99%;
            color  : Gray;
        }
        
        .x-grid-row-expanded td.x-grid-cell{
            border-bottom-width:0px;
        }
    </style>
</head>
<body>
    <form id="Form1" runat="server">
        <ext:ResourceManager ID="ResourceManager1" runat="server" DirectMethodNamespace="CompanyX">
            <Listeners>               
            </Listeners>
        </ext:ResourceManager>
        
        <asp:ObjectDataSource 
            ID="ObjectDataSource1" 
            runat="server"
            OnSelecting="ObjectSelecting"
            OnSelected="ObjectDataSource1_Selected"
            SelectMethod="GetFilter"
            TypeName="UyumSosyal.Moduls.Yetkilendirme_Islemleri.Shared.UserRol">
            <SelectParameters>
                <asp:Parameter Name="start" Type="Int32" />
                <asp:Parameter Name="limit" Type="Int32" />
                <asp:Parameter Name="sort" Type="Object" />                
                <asp:Parameter Name="count" Direction="Output" Type="Int32" />
                <asp:Parameter Name="arax" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>

        <asp:HiddenField ID="gizli" runat="server" Value="" />

        <ext:Window ID="PickWindowRolAdd" runat="server" Width="300" Height="210" AutoHeight="true" Title="Modül Ekle"
            Icon="Add" Hidden="true" Modal="true" InitCenter="true" Closable="false" Padding="5"
            LabelWidth="125" Layout="Form">
            <Items>

                <ext:SelectBox
                    ID="SelectBoxUser"
                    runat="server"
                    FieldLabel="Kullınıcı"
                    DisplayField="user_kod"
                    ValueField="id"
                    Editable="false"
                    EmptyText="Kullanıcı seçiniz...">
                    <Store>
                        <ext:Store runat="server">
                            <Model>
                                <ext:Model runat="server">
                                    <Fields>
                                        <ext:ModelField Name="id" />
                                        <ext:ModelField Name="user_kod" />
                                        <ext:ModelField Name="user_ad" />
                                        <ext:ModelField Name="user_soyad" />
                                        <ext:ModelField Name="user_sifre" />                                        
                                        <ext:ModelField Name="durum" />
                                    </Fields>
                                </ext:Model>
                            </Model>
                        </ext:Store>
                    </Store>
                </ext:SelectBox>                

                <ext:SelectBox
                    ID="SelectBoxRol"
                    runat="server"
                    FieldLabel="Rol"
                    DisplayField="rol_kod"
                    ValueField="id"
                    Editable="false"
                    EmptyText="Rol seçiniz...">
                    <Store>
                        <ext:Store runat="server">
                            <Model>
                                <ext:Model runat="server">
                                    <Fields>
                                        <ext:ModelField Name="id" />
                                        <ext:ModelField Name="rol_kod" />
                                        <ext:ModelField Name="aciklama" />
                                    </Fields>
                                </ext:Model>
                            </Model>
                        </ext:Store>
                    </Store>
                </ext:SelectBox>

            </Items>
            <Buttons>

                <ext:Button ID="ButtonTamam" runat="server" Text="Tamam" Icon="Accept">
                    <DirectEvents>
                        <Click OnEvent="ButtonSave">
                            <EventMask ShowMask="true" Msg="Kontrol ediliyor..." MinDelay="500" />
                        </Click>
                    </DirectEvents>
                </ext:Button>
                <ext:Button ID="ButtonVazgec" runat="server" Text="Vazgeç" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{PickWindowRolAdd}.hide();" />
                    </Listeners>
                </ext:Button>

            </Buttons>  
        </ext:Window> 

        <ext:Viewport ID="Viewport1" Layout="BorderLayout" runat="server">
            <Items> 
                <ext:Panel ID="Panel2" runat="server" Region="Center" Height="300" Header="false" Layout="Fit">
                    
                    <TopBar>
                        
                        <ext:Toolbar ID="Toolbar2" runat="server">
                            <Items>
                                
                                <ext:TextField 
                                    ID="TextFieldArama" 
                                    runat="server"
                                    EnableKeyEvents="true"
                                    LabelWidth="40"
                                    FieldLabel="Arama"                                            
                                    InputType="Text"
                                    Width="170">
                                    <Listeners>
                                        <KeyUp Delay="100" Fn="keyHandler" />
                                    </Listeners>
                                </ext:TextField>
                                
                                <ext:ToolbarSeparator/>

                                <ext:Button ID="BntSave" runat="server" Enabled="true" Text="Ekle" Icon="ApplicationAdd">
                                    <Listeners>
                                        <Click Handler="
                                                #{gizli}.setValue(''); 
                                                #{SelectBoxUser}.setValue(''); 
                                                #{SelectBoxRol}.setValue(''); 
                                                #{lbUser}.setText('Seçilen Rol : Yok!');
                                                #{PickWindowRolAdd}.setTitle('Ekle');
                                                #{PickWindowRolAdd}.show();" />
                                    </Listeners>
                                </ext:Button>

                                <ext:ToolbarSeparator/>
                                
                                <ext:Button ID="BtnEdit" runat="server" Enabled="true" Text="Düzelt" Icon="ApplicationEdit">
                                    <Listeners>
                                        <Click Handler="
                                        var v= #{GridPanel1}.getSelectionModel().getSelection();
                                        if (v.length==0) return;

                                        #{PickWindowRolAdd}.setTitle('Düzelt');
                                        #{SelectBoxRol}.setValue(v[0].data.aspnet_rol_id);
                                        #{SelectBoxUser}.setValue(v[0].data.aspnet_kullanici_id);                                     
                                        #{PickWindowRolAdd}.show();" />
                                    </Listeners>   
                                </ext:Button>

                                <ext:ToolbarSeparator/>
                                
                                <ext:Button ID="BtnRemove" runat="server" Enabled="true" Text="Sil" Icon="ApplicationDelete">
                                    <Listeners>
                                        <Click Handler="
                                                        var v= #{GridPanel1}.getSelectionModel().getSelection();
                                                        if (v.length==0) return;
                                                        Ext.MessageBox.confirm('Dikkat', 'Silmek istiyor musunız?\n('+v[0].data.kullanici + ')', showResult );" Delay="1"/>
                                    </Listeners>
                                </ext:Button>                                

                                <ext:ToolbarSeparator/>

                                <ext:Label ID="lbUser" runat="server" Text="Seçilen Rol : Yok!"></ext:Label>                                
                            </Items>
                        </ext:Toolbar>
                        
                    </TopBar>
                    
                    <Items>

                        <ext:GridPanel ID="GridPanel1" 
                            runat="server" 
                            Frame="true"
                            Height="600">
                            <Store>

                                <ext:Store 
                                    ID="Store1" 
                                    runat="server" 
                                    DataSourceID="ObjectDataSource1"
                                    RemoteSort="true"
                                    OnReadData="Store1_RefreshData"
                                    PageSize="23">
                                    <AutoLoadParams>
                                        <ext:Parameter Name="start" Value="0" Mode="Raw" />
                                        <ext:Parameter Name="limit" Value="23" Mode="Raw" />
                                    </AutoLoadParams>
                                    <Proxy>
                                        <ext:PageProxy />
                                    </Proxy>
                                    <Model>
                                        <ext:Model ID="Model1" runat="server" IDProperty="aspnet_rol_ids">
                                            <Fields>
                                                <ext:ModelField Name="id" />
                                                <ext:ModelField Name="aspnet_rol_id" />
                                                <ext:ModelField Name="rol" />
                                                <ext:ModelField Name="aspnet_kullanici_id" />
                                                <ext:ModelField Name="kullanici" />
                                            </Fields>
                                        </ext:Model>
                                    </Model>
                                    <Sorters>
                                        <ext:DataSorter Property="aspnet_rol_id" Direction="ASC" />
                                    </Sorters>
                                </ext:Store>

                            </Store>
                            <ColumnModel ID="ColumnModel1" runat="server">
                                <Columns>
                                    <ext:Column ID="Column3" runat="server" Text="Kullanıcı" DataIndex="kullanici" Width="230" />
                                    <ext:Column ID="Kod" runat="server" Text="Rol" DataIndex="rol" Width="230"  />
                                </Columns>
                            </ColumnModel>
                            <View>
                                <ext:GridView ID="GridView1" runat="server">
                                    <GetRowClass Handler="return 'x-grid-row-expanded';" />
                                </ext:GridView>        
                            </View>
                              
                            <SelectionModel>
                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single" />
                            </SelectionModel>
                            
                            <Listeners>
                                <Select Handler="
                                    var v= #{GridPanel1}.getSelectionModel().getSelection();
                                    if (v.length>0) { 
                                        #{gizli}.setValue(v[0].data.id); 
                                        #{lbUser}.setText('Seçilen Rol : ' + v[0].data.rol);}
                                    else {
                                        #{gizli}.setValue(''); 
                                        #{lbUser}.setText('Seçilen Rol : Yok!');} 
                                    "/>
                            </Listeners>

                            <BottomBar>
                                <ext:PagingToolbar ID="PagingToolbar1" 
                                    runat="server" 
                                    PageSize="23" 
                                    StoreID="Store1" 
                                    DisplayInfo="true" 
                                    DisplayMsg="Gösterilen {0} - {1} / {2}" 
                                    EmptyMsg="Kayıt yok."
                                />
                            </BottomBar>
                            <Features>
                                <ext:RowBody ID="RowBody1" runat="server" >
                                </ext:RowBody>
                            </Features>                            
                        </ext:GridPanel>

                    </Items>
                </ext:Panel>
            </Items>
        </ext:Viewport>  

    </form>
</body>
</html>
