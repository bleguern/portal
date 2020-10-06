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
		<title>TIME REPORT - Menu</title>
	</HEAD>
	<body>
		<form action="menu.aspx" id="MainForm" method="post" runat="server">
			<TABLE cellSpacing="0" cellPadding="0" border="0">
				<TR>
					<TD width="150" height="18"><a href="main.aspx" target="main"><IMG alt="Index" src="../../images/menu/menu_time_report.gif" border="0"></a></TD>
				</TR>
<%

if(IsAllowed("pages/donezat/account_list", false))
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

if(IsAllowed("pages/donezat/show_report", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../images/menu/menu_show_report.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="show_report/select_show_report.aspx" target="main"><IMG alt="Show time report for an user" src="../../images/menu/menu_show.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/donezat/admin", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../images/menu/menu_time_report_menu.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="admin/select_admin.aspx" target="main"><IMG alt="Time report administration" src="../../images/menu/menu_admin.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/donezat/validation_report", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../images/menu/menu_validation_report.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="validation_report/Default.aspx" target="main"><IMG alt="Show validation report" src="../../images/menu/menu_show.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/donezat/use_report", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../images/menu/menu_use_report.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="use_report/select_use_report.aspx" target="main"><IMG alt="Show use report" src="../../images/menu/menu_show.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/donezat/chargeable_report", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../images/menu/menu_chargeable_report.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="chargeable_report/select_chargeable_report.aspx" target="main"><IMG alt="Show chargeable report" src="../../images/menu/menu_show.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/donezat/usability_report", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../images/menu/menu_usability_report.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="usability_report/select_usability_report.aspx" target="main"><IMG alt="Show usability report" src="../../images/menu/menu_show.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/donezat/customer_report", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../images/menu/menu_customer_report.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="customer_report/select_customer_report.aspx" target="main"><IMG alt="Show customer report" src="../../images/menu/menu_show.gif" border="0"></a></TD>
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

