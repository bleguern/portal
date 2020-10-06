<%@ Page Language="C#" %>
<!-- #Include File="../../config/util.cs" -->
<%
	if(!IsAllowed(Request.ServerVariables["URL"], true))
	{
		Response.Redirect("../../not_allowed.aspx");
	}
%>
<HTML>
	<HEAD>
		<title>EXPENSES - Menu</title>
	</HEAD>
	<body>
		<form action="menu.aspx" id="MainForm" method="post" runat="server">
			<TABLE cellSpacing="0" cellPadding="0" border="0">
				<TR>
					<TD width="150" height="18"><a href="main.aspx" target="main"><IMG alt="Index" src="../../images/menu/menu_expenses.gif" border="0"></a></TD>
				</TR>
<%

if(IsAllowed("pages/expenses/account_list", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../images/menu/menu_account_list.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="account_list/manage_account_list.aspx" target="main"><IMG alt="Manage account list" src="../../images/menu/menu_manage.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/expenses/expenses_report", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../images/menu/menu_expenses_report.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="expenses_report/select_expenses_report.aspx" target="main"><IMG alt="Show expenses report" src="../../images/menu/menu_show.gif" border="0"></a></TD>
</TR>

<%

}

%>
				<TR>
					<TD width="150" height="18"></TD>
				</TR>
				<TR>
					<TD width="150" height="18"><a href="../../Default.aspx" target="_parent"><IMG alt="Go to portal" src="../../images/menu/menu_go_to_portal.gif" border="0"></a></TD>
				</TR>
			</TABLE>
		</form>
	</body>
</HTML>

