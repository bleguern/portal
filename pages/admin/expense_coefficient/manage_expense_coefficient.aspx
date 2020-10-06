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
<title>ADMINISTRATION - Manage expense coefficient</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			if(Session["sql_connection_string"] != null)
			{
				try
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
						
					ValueTextField.Value = sqlClient.ExecuteStoredProcedure("admin_get_expense_coefficient");
				}
				catch(PortalException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while getting expense coefficient!&message=" + ex.Message);
				}
				
			}
		}
	}
	
	void SaveButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if(ValueTextField.Value == "")
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			if(Session["sql_connection_string"] != null)
			{
				try
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
						
					string result = sqlClient.ExecuteStoredProcedure("admin_update_expense_coefficient",
						"@value", GetDoubleFromHtmlInputText(ValueTextField));
						
					InformationTextField.Value = result;
				}
				catch(PortalException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while modifying expense coefficient!&message=" + ex.Message);
				}
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
    			<td class="header">MANAGE EXPENSE COEFFICIENT</td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
	<tr>
	  <td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="50" class="text" align="left">Value : </td>
				<td width="5"></td>
				<td width="200"><input name="ValueTextField" type="text" class="text" id="ValueTextField" style="width:200px" maxlength="50" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="583"></td>
			</tr>
		</table>
	 </td>
	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	  <td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="center" width="300"><input name="SaveButton" class="text" type="submit" id="SaveButton" value="Save" runat="server" onServerClick="SaveButton_Click" alt="Save expense coefficient value" style="width:100px" /></td>
				<td width="550"></td>
			</tr>
		</table>
	 </td>
	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:850px;border-width:0px"
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