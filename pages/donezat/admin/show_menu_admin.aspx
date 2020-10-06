<%@ Page Language="C#" %>
<!-- #Include File="../../../config/util.cs" -->
<%
	if(!IsAllowed(Request.ServerVariables["URL"], true))
	{
		Response.Redirect("../../../not_allowed.aspx");
	}
%>
<HTML>
	<HEAD>
		<title>TIME REPORT ADMINISTRATION FOR USER : <%= Request["name"].ToString() %> - Menu</title>
	</HEAD>
	<body>
		<form action="menu.aspx" id="MainForm" method="post" runat="server">
			<TABLE cellSpacing="0" cellPadding="0" border="0">
				<TR>
					<TD width="150" height="18"><a href="show_main_admin.aspx?user_id=<%= Request["user_id"].ToString() %>&name=<%= Request["name"].ToString() %>" target="main"><IMG alt="Index" src="../../../images/menu/menu_time_report.gif" border="0"></a></TD>
				</TR>
				<TR>
					<TD width="150" height="18"></TD>
				</TR>
				<TR>
					<TD width="150" height="18"><IMG src="../../../images/menu/menu_account_list.gif" border="0"></TD>
				</TR>
				<TR>
					<TD width="150" height="18"><a href="show_account_list_admin.aspx?user_id=<%= Request["user_id"].ToString() %>&name=<%= Request["name"].ToString() %>" target="main"><IMG alt="Manage account list" src="../../../images/menu/menu_manage.gif" border="0"></a></TD>
				</TR>
				<TR>
					<TD width="150" height="18"></TD>
				</TR>
				<TR>
					<TD width="150" height="18"><input name="CloseButton" type="image" onClick="javascript:parent.window.close()" src="../../../images/menu/menu_close.gif" alt="Close window"></TD>
				</TR>
			</TABLE>
		</form>
	</body>
</HTML>

