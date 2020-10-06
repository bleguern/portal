<%@ Page Language="C#" %>
<!-- #Include File="../../config/util.cs" -->
<%
	if(!IsAllowed(Request.ServerVariables["URL"], true))
	{
		Response.Redirect("../../not_allowed.aspx");
	}
%>
<html>
	<head>
		<TITLE>EXPENSES - Main</TITLE>
	</head>
	<frameset border="0" frameSpacing="0" frameBorder="0" rows="570,*">
		<frame name="main_head" src="main_edit.aspx" frameBorder="no">
		<frame name="main_bottom" src="list.aspx" frameBorder="no">
		<noframes>
			<p>
				<b>Error</b> : Your browser doesn't support frames!
			</p>
		</noframes>
	</frameset>
</html>