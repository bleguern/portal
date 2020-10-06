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
<title>ADMINISTRATION - Select a customer to update</title>
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
				
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref CustomerSelect, "admin_get_customer_list_to_html_select");
			}
		}
	}
	
	void UpdateCustomerButton_Click(Object sender, EventArgs e) {
		if(CustomerSelect.SelectedIndex != 0)
		{
			Response.Redirect("update_customer.aspx?customer_id=" + CustomerSelect.Value);
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
    			<td class="header">SELECT A CUSTOMER TO UPDATE</td>
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
				<td width="60" class="text" align="left">Customer : </td>
			    <td width="5"></td>
			    <td width="400"><select id="CustomerSelect" name="CustomerSelect" size="1" class="text" style="width:400px"
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
      	 <td><input type="submit" class="text" runat="server" style="width:100px" id="UpdateCustomerButton" name="UpdateCustomerButton" alt="Update customer" value="Update" onServerClick="UpdateCustomerButton_Click"></td>
      	</tr>
	  </table>
	  </td>
    </tr>
</table>
</form>
</body>
</html>
