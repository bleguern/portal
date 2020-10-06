<%@ Page Language="C#" %>
<!-- #Include file="../../config/util.cs" -->
<html>
<head>
<title>DELIA SYSTEMS PORTAL - Error</title>
<LINK href="../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			InformationTextField.Value = Request["error"];
		}
	}
	
	string GetMailUrl()
	{
		return "mailto:" + GetAdministratorEmail() +
			"?subject=PTL - Error&body=" + 
			"Version :" + GetApplicationVersion() + "%0D%0A" + 
			"Error : " + Request["error"] + "%0D%0A" + 
			"Message : " + Request["message"] + "%0D%0A" + 
			"User :" + User.Identity.Name + "%0D%0A" + 
			"Date : " + DateTime.Now.ToShortDateString() + " - " + DateTime.Now.ToLongTimeString();
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">DELIA SYSTEMS PORTAL ERROR</td>
  			</tr>
		</table>
	</td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:500px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
	 <td class="text" align="center"><A href="<%= GetMailUrl() %>">Contact administrator</A></td>
	</tr>
</table>
</form>
</body>
</html>
