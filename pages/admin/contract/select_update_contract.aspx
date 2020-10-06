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
<title>ADMINISTRATION - Select a contract to update</title>
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
				
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref ContractSelect, "admin_get_contract_list_to_html_select");
			}
		}
	}
	
	void UpdateContractButton_Click(Object sender, EventArgs e) {
		if(ContractSelect.SelectedIndex != 0)
		{
			Response.Redirect("update_contract.aspx?contract_id=" + ContractSelect.Value);
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
    			<td class="header">SELECT A CONTRACT TO UPDATE</td>
  			</tr>
		</table>
	</td>
  </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
	  <td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="70" class="text" align="left">Contract : </td>
			    <td width="5"></td>
			    <td width="395"><select id="ContractSelect" name="ContractSelect" size="1" class="text" style="width:395px"
										runat="server"></select></td>
				<td width="30"></td>
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
      	 <td><input type="submit" class="text" runat="server" style="width:100px" id="UpdateContractButton" name="UpdateContractButton" alt="Update contract" value="Update" onServerClick="UpdateContractButton_Click"></td>
      	</tr>
	  </table>
	  </td>
    </tr>
</table>
</form>
</body>
</html>
