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
<title>ADMINISTRATION - Transfer an account</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e)
	{
		string accountId = Request["account_id"];
		
		if(accountId != "")
		{
			if(!IsPostBack)
			{
				if(Session["sql_connection_string"] != null)
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
					sqlClient.UpdateHtmlSelectWithStoredProcedure(ref AccountSelect, "admin_get_account_list_with_account_to_html_select",
						"@id_account", accountId);
					
					string [] values = sqlClient.GetValuesWithStoredProcedure("admin_get_account_id",
						"@id_account", accountId);
					
					WarningTextField.Value = "Transfer the account : " + values[0];
				}
			}
		}
	}
	
	void TransferAccountButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if(AccountSelect.Value == "")
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			string accountId = Request["account_id"];
			
			if(!accountId.Equals(""))
			{
				if(Session["sql_connection_string"] != null)
				{
					try
					{
						PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
					
						string result = sqlClient.ExecuteStoredProcedure("admin_transfer_account",
							"@id_account", accountId,
							"@to_id_account", GetValueFromHtmlSelect(AccountSelect));
							
						InformationTextField.Value = result;
					}
					catch(PortalException ex)
					{
						Response.Redirect("../../error/Default.aspx?error=Internal error while transfering an account!&message=" + ex.Message);
					}
				}
			}
			else
			{
				InformationTextField.Value = "Error : Invalid data!";
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
    			<td class="header">TRANSFER AN ACCOUNT</td>
  			</tr>
		</table>
	</td>
  </tr>
  <tr>
    <td height="5"></td>
  </tr>
	<tr>
	 <td><input name="WarningTextField" type="text" class="red_bold" id="WarningTextField" style="width:500px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
    <tr>
	  <td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="100" class="text">To the account : </td>
			    <td width="5"></td>
			    <td width="300"><select id="AccountSelect" name="AccountSelect" size="1" class="text" style="width:300px"
										runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="83"></td>
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
      	 <td><input type="submit" class="text" runat="server" style="width:100px" id="TransferAccountButton" name="TransferAccountButton" alt="Transfer account" value="Transfer" onServerClick="TransferAccountButton_Click"></td>
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
