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
		<title>ADMINISTRATION - Menu</title>
	</HEAD>
	<body>
		<form action="menu.aspx" id="MainForm" method="post" runat="server">
			<TABLE cellSpacing="0" cellPadding="0" border="0">
				<TR>
					<TD width="150" height="18"><a href="main.aspx" target="main"><IMG alt="Index" src="../../images/menu/menu_administration.gif" border="0"></a></TD>
				</TR>
<%

if(IsAllowed("pages/admin/main", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="main/Default.aspx" target="_parent"><IMG alt="Main administration" src="../../images/menu/menu_main_menu.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/marie", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="marie/Default.aspx" target="_parent"><IMG alt="Trouble ticket administration" src="../../images/menu/menu_trouble_ticket_menu.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/donezat", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="donezat/Default.aspx" target="_parent"><IMG alt="Time report administration" src="../../images/menu/menu_time_report_menu.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/expenses", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="expenses/Default.aspx" target="_parent"><IMG alt="Expenses administration" src="../../images/menu/menu_expenses_menu.gif" border="0"></a></TD>
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

