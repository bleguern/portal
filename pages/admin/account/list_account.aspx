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
<title>ADMINISTRATION - Account list</title>
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
				
				sqlClient.UpdateDataGridWithStoredProcedure(ref AccountDataGrid, "admin_get_account_list");
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
    			<td class="header">ACCOUNT LIST</td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="AccountDataGrid" runat="server"
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
      DataKeyField="ID_ACCOUNT"
      AutoGenerateColumns="false"
    >

      <Columns>
        <asp:BoundColumn HeaderText="ID_ACCOUNT" Visible="false" ReadOnly="True" DataField="ID_ACCOUNT" ItemStyle-Wrap="false"/>
		<asp:HyperLinkColumn Target="_self"  HeaderStyle-Width="100" DataNavigateUrlField="ID_ACCOUNT" DataNavigateUrlFormatString="update_account.aspx?account_id={0}"
			DataTextField="ID" HeaderText="ID">
			<ItemStyle Font-Bold="True"></ItemStyle>
		</asp:HyperLinkColumn>
		<asp:TemplateColumn HeaderText="ACTIVE" HeaderStyle-Width="35" ItemStyle-HorizontalAlign="center">
			<ItemTemplate>
				<asp:CheckBox ID="ActiveCheckBox" Enabled="false" Runat="server" Checked='<%# DataBinder.Eval(Container.DataItem, "ACTIVE") %>'></asp:CheckBox>
			</ItemTemplate>
 		</asp:TemplateColumn>
		<asp:BoundColumn DataField="NAME" HeaderText="NAME" HeaderStyle-Width="300"></asp:BoundColumn>
		<asp:BoundColumn DataField="SECTOR" HeaderText="CHARGEABLE" HeaderStyle-Width="80"></asp:BoundColumn>
		<asp:TemplateColumn HeaderText="CIR" HeaderStyle-Width="25" ItemStyle-HorizontalAlign="center">
			<ItemTemplate>
				<asp:CheckBox ID="CirCheckBox" Enabled="false" Runat="server" Checked='<%# DataBinder.Eval(Container.DataItem, "IS_CIR") %>'></asp:CheckBox>
			</ItemTemplate>
 		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="R&D" HeaderStyle-Width="25" ItemStyle-HorizontalAlign="center">
			<ItemTemplate>
				<asp:CheckBox ID="RdCheckBox" Enabled="false" Runat="server" Checked='<%# DataBinder.Eval(Container.DataItem, "IS_RD") %>'></asp:CheckBox>
			</ItemTemplate>
 		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="B" HeaderStyle-Width="25" ItemStyle-HorizontalAlign="center">
			<ItemTemplate>
				<asp:CheckBox ID="BillableCheckBox" ToolTip="Billable" Enabled="false" Runat="server" Checked='<%# DataBinder.Eval(Container.DataItem, "IS_BILLABLE") %>'></asp:CheckBox>
			</ItemTemplate>
 		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="U" HeaderStyle-Width="25" ItemStyle-HorizontalAlign="center">
			<ItemTemplate>
				<asp:CheckBox ID="UseCheckBox" ToolTip="Use" Enabled="false" Runat="server" Checked='<%# DataBinder.Eval(Container.DataItem, "IS_USE") %>'></asp:CheckBox>
			</ItemTemplate>
 		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="NA" HeaderStyle-Width="25" ItemStyle-HorizontalAlign="center">
			<ItemTemplate>
				<asp:CheckBox ID="NoAccountableCheckBox" ToolTip="No Accoutable" Enabled="false" Runat="server" Checked='<%# DataBinder.Eval(Container.DataItem, "NO_ACCOUNTABLE") %>'></asp:CheckBox>
			</ItemTemplate>
 		</asp:TemplateColumn>
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