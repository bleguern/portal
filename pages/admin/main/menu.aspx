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
		<title>ADMINISTRATION - MAIN - Menu</title>
	</HEAD>
	<body>
		<form action="menu.aspx" id="MainForm" method="post" runat="server">
			<TABLE cellSpacing="0" cellPadding="0" border="0">
				<TR>
					<TD width="150" height="18"><a href="main.aspx" target="main"><IMG alt="Index" src="../../../images/menu/menu_main.gif" border="0"></a></TD>
				</TR>
<%

if(IsAllowed("pages/admin/user", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_user.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../user/add_user.aspx" target="main"><IMG alt="Add an user" src="../../../images/menu/menu_add.gif" border="0"></a></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../user/select_update_user.aspx" target="main"><IMG alt="Update an user" src="../../../images/menu/menu_update.gif" border="0"></a></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../user/list_user.aspx" target="main"><IMG alt="User list" src="../../../images/menu/menu_list.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/role", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_role.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../role/add_role.aspx" target="main"><IMG alt="Add a role" src="../../../images/menu/menu_add.gif" border="0"></a></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../role/select_update_role.aspx" target="main"><IMG alt="Update a role" src="../../../images/menu/menu_update.gif" border="0"></a></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../role/select_delete_role.aspx" target="main"><IMG alt="Delete a role" src="../../../images/menu/menu_delete.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/sites", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_sites.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../sites/manage_sites.aspx" target="main"><IMG alt="Manage sites" src="../../../images/menu/menu_manage.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/divisions", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_divisions.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../divisions/manage_divisions.aspx" target="main"><IMG alt="Manage divisions" src="../../../images/menu/menu_manage.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/password", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_user_password.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../password/update_password.aspx" target="main"><IMG alt="Update an user password" src="../../../images/menu/menu_update.gif" border="0"></a></TD>
</TR>

<%

}

%>
				<TR>
					<TD width="150" height="18"></TD>
				</TR>
				<TR>
					<TD width="150" height="18"><a href="../Default.aspx" target="_parent"><IMG alt="Go to administration" src="../../../images/menu/menu_go_to_admin.gif" border="0"></a></TD>
				</TR>
			</TABLE>
		</form>
	</body>
</HTML>

