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
		<title>ADMINISTRATION - EXPENSES - Menu</title>
	</HEAD>
	<body>
		<form action="../Copy%20of%20donezat/menu.aspx" id="MainForm" method="post" runat="server">
			<TABLE cellSpacing="0" cellPadding="0" border="0">
				<TR>
					<TD width="150" height="18"><a href="main.aspx" target="main"><IMG alt="Index" src="../../../images/menu/menu_expenses.gif" border="0"></a></TD>
				</TR>
<%

if(IsAllowed("pages/admin/account", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_account.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../account/add_account.aspx" target="main"><IMG alt="Add an account" src="../../../images/menu/menu_add.gif" border="0"></a></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../account/select_update_account.aspx" target="main"><IMG alt="Update an account" src="../../../images/menu/menu_update.gif" border="0"></a></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../account/select_transfer_account.aspx" target="main"><IMG alt="Transfer an account" src="../../../images/menu/menu_transfer.gif" border="0"></a></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../account/list_account.aspx" target="main"><IMG alt="Account list" src="../../../images/menu/menu_list.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/account_uses", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_account_uses.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../account_uses/manage_account_uses.aspx" target="main"><IMG alt="Manage account uses" src="../../../images/menu/menu_manage.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/expense_status", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_expense_status.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../expense_status/manage_expense_status.aspx" target="main"><IMG alt="Manage expense status" src="../../../images/menu/menu_manage.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/reception_types", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_reception_type.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../reception_types/manage_reception_types.aspx" target="main"><IMG alt="Manage reception type" src="../../../images/menu/menu_manage.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/expense_coefficient", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_expense_coefficient.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../expense_coefficient/manage_expense_coefficient.aspx" target="main"><IMG alt="Manage expense coefficient" src="../../../images/menu/menu_manage.gif" border="0"></a></TD>
</TR>

<%

}


if(IsAllowed("pages/admin/customer", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_customer.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../customer/add_customer.aspx" target="main"><IMG alt="Add a customer" src="../../../images/menu/menu_add.gif" border="0"></a></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../customer/select_update_customer.aspx" target="main"><IMG alt="Update a customer" src="../../../images/menu/menu_update.gif" border="0"></a></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../customer/list_customer.aspx" target="main"><IMG alt="Customer list" src="../../../images/menu/menu_list.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/customer_types", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_customer_types.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../customer_types/manage_customer_types.aspx" target="main"><IMG alt="Manage customer types" src="../../../images/menu/menu_manage.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/project", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_project.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../project/add_project.aspx" target="main"><IMG alt="Add a project" src="../../../images/menu/menu_add.gif" border="0"></a></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../project/select_update_project.aspx" target="main"><IMG alt="Update a project" src="../../../images/menu/menu_update.gif" border="0"></a></TD>
</TR>

<%

}

if(IsAllowed("pages/admin/contract", false))
{

%>

<TR>
	<TD width="150" height="18"></TD>
</TR>
<TR>
	<TD width="150" height="18"><IMG src="../../../images/menu/menu_contract.gif" border="0"></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../contract/add_contract.aspx" target="main"><IMG alt="Add a contract" src="../../../images/menu/menu_add.gif" border="0"></a></TD>
</TR>
<TR>
	<TD width="150" height="18"><a href="../contract/select_update_contract.aspx" target="main"><IMG alt="Update a contract" src="../../../images/menu/menu_update.gif" border="0"></a></TD>
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

