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
<title>ADMINISTRATION - Manage account uses</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			UpdateAccountUseDataGrid();
		}
	}
	
	void AddAccountUseButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if((TrigTextField.Value == "")
		|| (NameTextField.Value == ""))
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			if(Session["sql_connection_string"] != null)
			{
				try
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
						
					string result = sqlClient.ExecuteStoredProcedure("admin_add_account_use",
						"@trigram", GetValueFromHtmlInputText(TrigTextField, true),
						"@name", GetValueFromHtmlInputText(NameTextField, true));
					
					UpdateAccountUseDataGrid();
					InformationTextField.Value = result;
					TrigTextField.Value = null;
					NameTextField.Value = null;
				}
				catch(PortalSqlErrorException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while adding an account use!&message=" + ex.Message);
				}
				catch(PortalSqlConstraintsException ex)
				{
					InformationTextField.Value = "WARNING : TRIGRAM already exist!";
				}
			}
		}
	}
	
	void AccountUseDataGrid_Edit(Object sender, DataGridCommandEventArgs e)
    {
        AccountUseDataGrid.EditItemIndex = (int)e.Item.ItemIndex;
        UpdateAccountUseDataGrid();
    }

    void AccountUseDataGrid_Cancel(Object sender, DataGridCommandEventArgs e)
    {
        AccountUseDataGrid.EditItemIndex = -1;
        UpdateAccountUseDataGrid();
    }

    void AccountUseDataGrid_Update(Object sender, DataGridCommandEventArgs e)
    {
		InformationTextField.Value = null;

		if((((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditNameTextField")).Value == "")
		|| (((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditTrigTextField")).Value == ""))
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			if(Session["sql_connection_string"] != null)
			{
				try
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
						
					string result = sqlClient.ExecuteStoredProcedure("admin_update_account_use",
						"@id_account_use", AccountUseDataGrid.DataKeys[(int)e.Item.ItemIndex],
						"@trigram", GetValueFromHtmlInputText(((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditTrigTextField")), true),
						"@name", GetValueFromHtmlInputText(((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditNameTextField")), true));
				
					AccountUseDataGrid.EditItemIndex = -1;
					UpdateAccountUseDataGrid();
					InformationTextField.Value = result;
				}
				catch(PortalSqlErrorException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while updating an account use!&message=" + ex.Message);
				}
				catch(PortalSqlConstraintsException ex)
				{
					InformationTextField.Value = "WARNING : TRIGRAM already exist!";
				}
			}
		}
    }
	
	void UpdateAccountUseDataGrid()
    {
       	if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataGridWithStoredProcedure(ref AccountUseDataGrid, "admin_get_account_use_list");
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
    			<td class="header">MANAGE ACCOUNT USES</td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="AccountUseDataGrid" runat="server"
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
      OnEditCommand="AccountUseDataGrid_Edit"
      OnCancelCommand="AccountUseDataGrid_Cancel"
      OnUpdateCommand="AccountUseDataGrid_Update"
      DataKeyField="ID"
      AutoGenerateColumns="false"
    >

      <Columns>
        <asp:BoundColumn HeaderText="ID" Visible="false" SortExpression="ID" ReadOnly="True" DataField="ID" ItemStyle-Wrap="false"/>
		<asp:TemplateColumn HeaderText="TRIGRAM" HeaderStyle-Width="200" SortExpression="TRIGRAM">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "TRIGRAM") %>'/>
          </ItemTemplate>
          <EditItemTemplate>
		  	<input id="EditTrigTextField" name="EditTrigTextField" type="text" class="text"  style="width:200px" maxlength="3" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "TRIGRAM") %>'>
          </EditItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="NAME" HeaderStyle-Width="500" SortExpression="NAME">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'/>
          </ItemTemplate>
          <EditItemTemplate>
		  	<input id="EditNameTextField" name="EditNameTextField" type="text" class="text"  style="width:500px" maxlength="50" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'>
          </EditItemTemplate>
        </asp:TemplateColumn>
		<asp:EditCommandColumn ButtonType="PushButton" EditText="Update" CancelText="Cancel" UpdateText="Update" ItemStyle-Wrap="false"/>
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
    			<td class="header">ADD AN ACCOUNT USE</td>
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
				<td width="50" class="text" align="left">Trigram : </td>
				<td width="5"></td>
				<td width="100"><input name="TrigTextField" type="text" class="text" id="TrigTextField" style="width:100px" maxlength="3" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="50" class="text" align="center">Name : </td>
				<td width="5"></td>
				<td width="500"><input name="NameTextField" type="text" class="text" id="NameTextField" style="width:500px" maxlength="50" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td align="center"><input type="submit" class="text" runat="server" style="width:100px" id="AddAccountUseButton" name="AddAccountUseButton" alt="Add an account use" value="Add" onServerClick="AddAccountUseButton_Click"></td>
			</tr>
		</table>
	 </td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:850px;border-width:0px"
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