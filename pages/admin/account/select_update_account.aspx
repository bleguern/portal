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
<title>ADMINISTRATION - Select an account to update</title>
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
				
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref AccountSelect, "admin_get_account_list_to_html_select");
			}
		}
	}
	
	void UpdateAccountButton_Click(Object sender, EventArgs e) {
		if(AccountSelect.SelectedIndex != 0)
		{
			Response.Redirect("update_account.aspx?account_id=" + AccountSelect.Value);
		}
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">SELECT AN ACCOUNT TO UPDATE</td>
  			</tr>
		</table>
	</td>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
	  <td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="60" class="text" align="left">Account : </td>
			    <td width="5"></td>
			    <td width="400"><select id="AccountSelect" name="AccountSelect" size="1" class="text" style="width:400px"
										runat="server"></select></td>
				<td width="35"></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
    <tr>
	  <td>
	  <table width="500" border="0" cellspacing="0" cellpadding="0">
		<tr align="center">
      	 <td><input type="submit" class="text" runat="server" style="width:100px" id="UpdateAccountButton" name="UpdateAccountButton" alt="Update account" value="Update" onServerClick="UpdateAccountButton_Click"></td>
      	</tr>
	  </table>
	  </td>
    </tr>
</table>
</form>
</body>
</html>
