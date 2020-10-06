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
<title>ADMINISTRATION - Select a role to delete</title>
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
				
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref RoleSelect, "admin_get_role_list_to_html_select");
			}
		}
	}
	
	void DeleteRoleButton_Click(Object sender, EventArgs e) {
		if(RoleSelect.SelectedIndex != 0)
		{
			Response.Redirect("delete_role.aspx?role_id=" + RoleSelect.Value);
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
    			<td class="header">SELECT A ROLE TO DELETE</td>
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
				<td width="50" class="text" align="left">Role : </td>
			    <td width="5"></td>
			    <td width="400"><select id="RoleSelect" name="RoleSelect" size="1" class="text" style="width:400px"
										runat="server"></select></td>
				<td width="45"></td>
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
      	 <td><input type="submit" class="text" runat="server" style="width:100px" id="DeleteRoleButton" name="DeleteRoleButton" alt="Delete role" value="Delete" onServerClick="DeleteRoleButton_Click"></td>
      	</tr>
	  </table>
	  </td>
    </tr>
</table>
</form>
</body>
</html>
