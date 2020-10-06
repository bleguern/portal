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
<title>ADMINISTRATION - Delete a role</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			string roleId = Request["role_id"];
			
			if(!roleId.Equals(""))
			{
				if(Session["sql_connection_string"] != null)
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
					string [] values = sqlClient.GetValuesWithStoredProcedure("admin_get_role_name",
						"@id_role", roleId);
				
					WarningTextField.Value = "Are you sure you want to delete the role nammed : " + values[0] + "?";
				}
			}
		}
	}
	
	void DeleteRoleButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		string roleId = Request["role_id"];
						
		if(!roleId.Equals(""))
		{
			if(Session["sql_connection_string"] != null)
			{
				try
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
						
					string result = sqlClient.ExecuteStoredProcedure("admin_delete_role",
						"@id_role", roleId);
						
					if(result.Equals("1"))
					{
						InformationTextField.Value = "Role n°" + roleId + " deleted!";
					}
					else if(result.Equals("0"))
					{
						InformationTextField.Value = "WARNING : You can't delete a role as long as it get users!";
					}
				}
				catch(PortalException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while deleting a role!&message=" + ex.Message);
				}
			}
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
    			<td class="header">DELETE A ROLE</td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
	<tr>
	 <td><input name="WarningTextField" type="text" class="red" id="WarningTextField" style="width:500px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
    <tr>
	  <td>
	  <table width="500" border="0" cellspacing="0" cellpadding="0">
		<tr>
      	 <td width="100"></td>
		 <td width="400"><input type="submit" class="text" runat="server" style="width:100px" id="DeleteRoleButton" name="DeleteRoleButton" alt="Delete role" value="Delete" onServerClick="DeleteRoleButton_Click"></td>
      	</tr>
	  </table>
	  </td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:500px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
		<td class="red">* : Mandatory fields</td>
	</tr>
</table>
</form>
</body>
</html>