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
		<TITLE>TIME REPORT ADMINISTRATION FOR USER : <%= Request["name"].ToString() %></TITLE>
	</head>
	<frameset border="0" frameSpacing="0" borderColor="black" frameBorder="0" cols="175,83%">
		<frame name="menu" src="show_menu_admin.aspx?user_id=<%= Request["user_id"].ToString() %>&name=<%= Request["name"].ToString() %>" frameBorder="no">
		<frame name="main" src="show_main_admin.aspx?user_id=<%= Request["user_id"].ToString() %>&name=<%= Request["name"].ToString() %>" frameBorder="no">
		<noframes>
			<p>
				<b>Error</b> : Your browser doesn't support frames!
			</p>
		</noframes>
	</frameset>
</html>