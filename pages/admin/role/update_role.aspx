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
<title>ADMINISTRATION - Update a role</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			string roleId = Request["role_id"];
			
			if(!roleId.Equals(""))
			{
				if(Session["sql_connection_string"] != null)
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
					string [] values = sqlClient.GetValuesWithStoredProcedure("admin_get_role",
						"@id_role", roleId);
				
					NameTextField.Value = values[0];
					SqlLoginTextField.Value = values[1];
					SqlPasswordTextField.Value = values[2];
					
					UpdateAccessDataGrid();
					UpdateAccessHtmlSelect();
				}
			}
		}
	}

	void AccessDataGrid_Delete(Object sender, DataGridCommandEventArgs e)
    {
        AccessInformationTextField.Value = null;
		
		string roleId = Request["role_id"];
					
		if(!roleId.Equals(""))
		{
			if(Session["sql_connection_string"] != null)
			{
				try
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
						
					string result = sqlClient.ExecuteStoredProcedure("admin_delete_access_from_role",
						"@id_role", roleId,
						"@id_site", AccessDataGrid.DataKeys[(int)e.Item.ItemIndex]);
						
					UpdateAccessDataGrid();
					UpdateAccessHtmlSelect();
					AccessInformationTextField.Value = result;
				}
				catch(PortalException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while removing an access!&message=" + ex.Message);
				}
			}
		}
    }
	
	void AddAccessButton_Click(Object sender, EventArgs e) {
		AccessInformationTextField.Value = null;
		
		if(AccessSelect.SelectedIndex != 0)
		{
			string roleId = Request["role_id"];
						
			if(!roleId.Equals(""))
			{
				if(Session["sql_connection_string"] != null)
				{
					try
					{
						PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
							
						string result = sqlClient.ExecuteStoredProcedure("admin_add_access_to_role",
							"@id_role", roleId,
							"@id_site", GetValueFromHtmlSelect(AccessSelect));
						
						UpdateAccessDataGrid();
						UpdateAccessHtmlSelect();
						AccessInformationTextField.Value = result;
					}
					catch(PortalException ex)
					{
						Response.Redirect("../../error/Default.aspx?error=Internal error while adding an access!&message=" + ex.Message);
					}
				}
			}
		}
	}
	
	void SaveRoleButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if((NameTextField.Value == "")
		|| (SqlLoginTextField.Value == "")
		|| (SqlPasswordTextField.Value == ""))
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			string roleId = Request["role_id"];
						
			if(!roleId.Equals(""))
			{
				if(Session["sql_connection_string"] != null)
				{
					try
					{
						PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
							
						string result = sqlClient.ExecuteStoredProcedure("admin_update_role",
							"@id_role", roleId,
							"@name", GetValueFromHtmlInputText(NameTextField, true),
							"@sql_login", GetValueFromHtmlInputText(SqlLoginTextField, true),
							"@sql_password", GetValueFromHtmlInputText(SqlPasswordTextField, true));
							
						InformationTextField.Value = result;
					}
					catch(PortalSqlErrorException ex)
					{
						Response.Redirect("../../error/Default.aspx?error=Internal error while updating a role!&message=" + ex.Message);
					}
					catch(PortalSqlConstraintsException ex)
					{
						InformationTextField.Value = "WARNING : NAME already exist!";
					}
				}
			}
		}
	}
	
	void UpdateAccessDataGrid()
    {
		string roleId = Request["role_id"];
					
		if(!roleId.Equals(""))
		{
			if(Session["sql_connection_string"] != null)
			{
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
				sqlClient.UpdateDataGridWithStoredProcedure(ref AccessDataGrid, "admin_get_access_list_with_role",
					"@role_id", roleId);
			}
		}
    }
	
	void UpdateAccessHtmlSelect()
	{
		string roleId = Request["role_id"];
					
		if(roleId != "")
		{
			if(Session["sql_connection_string"] != null)
			{
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref AccessSelect, "admin_get_unaccess_list_with_role_to_html_select",
					"@role_id", roleId);
			}
		}
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="850" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">UPDATE A ROLE</td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
	  <td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="80" class="text">Name : </td>
			    <td width="5"></td>
			    <td width="300"><input name="NameTextField" type="text" class="text" id="NameTextField" style="width:300px" maxlength="50" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="453"></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
    <tr>
	  <td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="80" class="text">Sql login : </td>
			    <td width="5"></td>
			    <td width="200"><input name="SqlLoginTextField" type="text" class="text" id="SqlLoginTextField" style="width:200px" maxlength="20" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="553"></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="5"></td>
	</tr>
    <tr>
	  <td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="80" class="text">Sql password : </td>
			    <td width="5"></td>
			    <td width="200"><input name="SqlPasswordTextField" type="text" class="text" id="SqlPasswordTextField" style="width:200px" maxlength="20" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="553"></td>
			</tr>
		</table>
	 </td>
    </tr>
  <tr>
    <td height="10"></td>
  </tr>
    <tr>
	  <td>
	  <table width="850" border="0" cellspacing="0" cellpadding="0">
		<tr>
      	 <td width="150"></td>
		 <td width="700"><input type="submit" class="text" runat="server" style="width:100px" id="SaveRoleButton" name="SaveRoleButton" alt="Save role" value="Save" onServerClick="SaveRoleButton_Click"></td>
      	</tr>
	  </table>
	  </td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:850px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
  <tr>
  	<td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">ACCESS LIST</td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="AccessDataGrid" runat="server"
      Width="850"
      BackColor="#FFFFFF"
      BorderColor="black"
      ShowFooter="false"
      CellPadding=3
      CellSpacing="0"
      Font-Name="Verdana"
      Font-Size="8pt"
      HeaderStyle-BackColor="#DE0029"
	  HeaderStyle-ForeColor="#FFFFFF"
	  HeaderStyle-Font-Bold="true"
	  OnDeleteCommand="AccessDataGrid_Delete"
      DataKeyField="ID"
      AutoGenerateColumns="false"
    >


      <Columns>
        <asp:BoundColumn HeaderText="ID" SortExpression="ID" ReadOnly="True" DataField="ID" ItemStyle-Wrap="false"/>
        <asp:TemplateColumn HeaderText="NAME" HeaderStyle-Width="200" SortExpression="NAME">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="URL" HeaderStyle-Width="500" SortExpression="URL">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "URL") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:ButtonColumn ButtonType="PushButton" Text="Remove" CommandName="Delete"/>
      </Columns>
    </ASP:DataGrid>
	</td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
   <tr>
  	<td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">ADD AN ACCESS</td>
  			</tr>
		</table>
	</td>
   </tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
	  <td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="60" class="text" align="left">Access : </td>
				<td width="5"></td>
				<td width="600"><select id="AccessSelect" name="AccessSelect" size="1" class="text" style="width:600px"
										runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td align="center"><input type="submit" class="text" runat="server" style="width:100px" id="AddAccessButton" name="AddAccessButton" alt="Add an access to role" value="Add" onServerClick="AddAccessButton_Click"></td>
			</tr>
		</table>
	 </td>
	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	 <td><input name="AccessInformationTextField" type="text" class="red" id="AccessInformationTextField" style="width:850px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
		<td class="red">* : Mandatory fields</td>
	</tr>
</table>
</form>
</body>
</html>