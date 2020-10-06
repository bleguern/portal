<%@ Page Language="C#" %>
<!-- #Include File="../../../config/util.cs" -->
<%
	if(!IsAllowed(Request.ServerVariables["URL"], true))
	{
		Response.Redirect("../../../not_allowed.aspx");
	}
%>
<html>
<head>
<title>ADMINISTRATION - User list</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			if(Session["sql_connection_string"] != null)
			{
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
				sqlClient.UpdateDataGridWithStoredProcedure(ref UserDataGrid, "admin_get_user_list");
			}
		}
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="850" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">USER LIST</td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="UserDataGrid" runat="server"
      Width="850"
      BackColor="#FFFFFF"
      BorderColor="black"
      ShowFooter="false"
      CellPadding=3
      CellSpacing="0"
      Font-Name="Verdana"
      Font-Size="8pt"
      HeaderStyle-BackColor="#DE0029"
	  HeaderStyle-ForeColor="#FFFFFF"
	  HeaderStyle-Font-Bold="true"
      DataKeyField="ID_USER"
      AutoGenerateColumns="false"
    >

      <Columns>
        <asp:BoundColumn HeaderText="ID_USER" Visible="false" ReadOnly="True" DataField="ID_USER" ItemStyle-Wrap="false"/>
		<asp:HyperLinkColumn Target="_self"  HeaderStyle-Width="60" DataNavigateUrlField="ID_USER" DataNavigateUrlFormatString="update_user.aspx?user_id={0}"
			DataTextField="TRIGRAM" HeaderText="TRIGRAM">
			<ItemStyle Font-Bold="True"></ItemStyle>
		</asp:HyperLinkColumn>
		<asp:TemplateColumn HeaderText="ACTIVE" HeaderStyle-Width="40" ItemStyle-HorizontalAlign="center">
			<ItemTemplate>
				<asp:CheckBox ID="ActiveCheckBox" Enabled="false" Runat="server" Checked='<%# DataBinder.Eval(Container.DataItem, "ACTIVE") %>'></asp:CheckBox>
			</ItemTemplate>
 		</asp:TemplateColumn>
		<asp:BoundColumn DataField="LOGIN" HeaderText="LOGIN" HeaderStyle-Width="50"></asp:BoundColumn>
		<asp:BoundColumn DataField="FIRST_NAME" HeaderText="FIRST NAME" HeaderStyle-Width="150"></asp:BoundColumn>
		<asp:BoundColumn DataField="LAST_NAME" HeaderText="LAST NAME" HeaderStyle-Width="150"></asp:BoundColumn>
		<asp:BoundColumn DataField="SECTOR" HeaderText="DIVISION" HeaderStyle-Width="100"></asp:BoundColumn>
		<asp:BoundColumn DataField="ROLE" HeaderText="ROLE" HeaderStyle-Width="100"></asp:BoundColumn>
		<asp:HyperLinkColumn Target="_blank" HeaderStyle-Width="150" DataNavigateUrlField="EMAIL" DataNavigateUrlFormatString="mailto:{0}"
			DataTextField="EMAIL" HeaderText="EMAIL">
			<ItemStyle Font-Bold="True"></ItemStyle>
		</asp:HyperLinkColumn>
      </Columns>
    </ASP:DataGrid>
	</td>
    </tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:850px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
</table>
</form>
</body>
</html>