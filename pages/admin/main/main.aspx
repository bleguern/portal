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
<title>ADMINISTRATION - MAIN - Main</title>
<link href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
	<script language="C#" runat="server">
		void Page_Load(Object sender, EventArgs e) 
		{
			InformationTextField.Value = "Welcome to Administration - Main, you are connected as " + User.Identity.Name.ToUpper() + " on " + Session["server"].ToString();
		}
	</script>
<body>
<form id="MainForm" method="post" runat="server">
  <table width="850" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td class="header">ADMINISTRATION - MAIN</td>
  </tr>
  <tr>
    <td height="10"></td>
  </tr>
  <tr>
    <td><input name="InformationTextField" type="text" class="welcome" id="InformationTextField" style="width:850px;border-width:0px" readonly="true" runat="server"></td>
  </tr>
  </table>
</form>
</body>
</html>
