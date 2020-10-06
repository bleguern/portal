<%@ Page Language="C#" %>
<html>
<head>
<title>DELIA SYSTEMS PORTAL - Not allowed !</title>
<link href="css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		InformationTextField.Value = "You are not allowed to access this page, you are connected as " + User.Identity.Name.ToUpper();
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
  <table width="850" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td class="header">NOT ALLOWED !</td>
  </tr>
  <tr>
    <td height="10"></td>
  </tr>
  <tr>
    <td><input name="InformationTextField" type="text" class="welcome" id="InformationTextField" style="width:850px;border-width:0px" readonly="true" runat="server"></td>
  </tr>
  <tr>
    <td height="10"></td>
  </tr>
  <tr>
    <td class="welcome" align="center"><a href="Default.aspx" target="_parent">Return to portal</a></td>
  </tr>
  </table>
</form>
</body>
</html>
