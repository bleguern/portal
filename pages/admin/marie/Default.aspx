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
		<TITLE>ADMINISTRATION - TROUBLE TICKET</TITLE>
	</head>
	<frameset border="0" frameSpacing="0" borderColor="black" frameBorder="0" cols="175,83%">
		<frame name="menu" src="menu.aspx" frameBorder="no">
		<frame name="main" src="main.aspx" frameBorder="no">
		<noframes>
			<p>
				<b>Error</b> : Your browser doesn't support frames!
			</p>
		</noframes>
	</frameset>
</html>
