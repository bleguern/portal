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
<title>ADMINISTRATION - Manage activity durations</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			UpdateActivityDurationsDataGrid();
		}
	}
	
	void AddActivityDurationButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if((ValueTextField.Value == "")
		|| (DurationTextField.Value == "")
		|| (OverTimeSelect.Value == ""))
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
						
					string result = sqlClient.ExecuteStoredProcedure("admin_add_activity_duration",
						"@value", GetValueFromHtmlInputText(ValueTextField, true),
						"@duration_in_minutes", GetValueFromHtmlInputText(DurationTextField, true),
						"@is_overtime", GetValueFromHtmlSelect(OverTimeSelect));
						
					UpdateActivityDurationsDataGrid();
					InformationTextField.Value = result;
					ValueTextField.Value = null;
					DurationTextField.Value = null;
					OverTimeSelect.SelectedIndex = 0;
				}
				catch(PortalSqlErrorException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while adding an activity duration!&message=" + ex.Message);
				}
				catch(PortalSqlConstraintsException ex)
				{
					InformationTextField.Value = "WARNING : VALUE already exist!";
				}
			}
		}
	}
	
	void ActivityDurationsDataGrid_Edit(Object sender, DataGridCommandEventArgs e)
    {
        ActivityDurationsDataGrid.EditItemIndex = (int)e.Item.ItemIndex;
        UpdateActivityDurationsDataGrid();
    }

    void ActivityDurationsDataGrid_Cancel(Object sender, DataGridCommandEventArgs e)
    {
        ActivityDurationsDataGrid.EditItemIndex = -1;
        UpdateActivityDurationsDataGrid();
    }

    void ActivityDurationsDataGrid_Update(Object sender, DataGridCommandEventArgs e)
    {
		InformationTextField.Value = null;

		if((((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditValueTextField")).Value == "")
		|| (((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditDurationTextField")).Value == ""))
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
						
					string result = sqlClient.ExecuteStoredProcedure("admin_update_activity_duration",
						"@id_activity_duration", ActivityDurationsDataGrid.DataKeys[(int)e.Item.ItemIndex],
						"@value", GetValueFromHtmlInputText(((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditValueTextField")), true),
						"@duration_in_minutes", GetValueFromHtmlInputText(((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditDurationTextField")), true),
						"@is_overtime", GetValueFromCheckBox(((System.Web.UI.WebControls.CheckBox)e.Item.FindControl("OverTimeCheckBox"))));
				
					ActivityDurationsDataGrid.EditItemIndex = -1;
					UpdateActivityDurationsDataGrid();
					InformationTextField.Value = result;
				}
				catch(PortalSqlErrorException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while updating an activity duration!&message=" + ex.Message);
				}
				catch(PortalSqlConstraintsException ex)
				{
					InformationTextField.Value = "WARNING : VALUE already exist!";
				}
			}
		}
    }
	
	void ActivityDurationsDataGrid_Delete(Object sender, DataGridCommandEventArgs e)
    {
		InformationTextField.Value = null;
		
        if(Session["sql_connection_string"] != null)
		{
			try
			{
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
				string result = sqlClient.ExecuteStoredProcedure("admin_delete_activity_duration",
					"@id_activity_duration", ActivityDurationsDataGrid.DataKeys[(int)e.Item.ItemIndex]);
					
				UpdateActivityDurationsDataGrid();
				InformationTextField.Value = result;
			}
			catch(PortalException ex)
			{
				Response.Redirect("../../error/Default.aspx?error=Internal error while deleting an activity duration!&message=" + ex.Message);
			}
		}
    }

	
	void UpdateActivityDurationsDataGrid()
    {
       	if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataGridWithStoredProcedure(ref ActivityDurationsDataGrid, "admin_get_activity_duration_list");
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
    			<td class="header">MANAGE ACTIVITY DURATIONS</td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="ActivityDurationsDataGrid" runat="server"
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
      OnEditCommand="ActivityDurationsDataGrid_Edit"
      OnCancelCommand="ActivityDurationsDataGrid_Cancel"
      OnUpdateCommand="ActivityDurationsDataGrid_Update"
	  OnDeleteCommand="ActivityDurationsDataGrid_Delete"
      DataKeyField="ID"
      AutoGenerateColumns="false"
    >

      <Columns>
        <asp:BoundColumn HeaderText="ID" Visible="false" SortExpression="ID" ReadOnly="True" DataField="ID" ItemStyle-Wrap="false"/>
        <asp:TemplateColumn HeaderText="VALUE" HeaderStyle-Width="250">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "VALUE") %>'/>
          </ItemTemplate>
          <EditItemTemplate>
		  	<input id="EditValueTextField" name="EditValueTextField" type="text" class="text"  style="width:250px" maxlength="4" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "VALUE") %>'>
          </EditItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="DURATION IN MINUTES" HeaderStyle-Width="300">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "DURATION") %>'/>
          </ItemTemplate>
          <EditItemTemplate>
		  	<input id="EditDurationTextField" name="EditDurationTextField" type="text" class="text"  style="width:300px" maxlength="8" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "DURATION") %>'>
          </EditItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="OVERTIME" HeaderStyle-Width="100">
			<ItemTemplate>
				<asp:CheckBox ID="OverTimeCheckBox" Enabled="false" Runat="server" Checked='<%# DataBinder.Eval(Container.DataItem, "OVERTIME") %>'></asp:CheckBox>
			</ItemTemplate>
			<EditItemTemplate>
            	<asp:CheckBox ID="OverTimeCheckBox" Enabled="true" Runat="server" Checked='<%# DataBinder.Eval(Container.DataItem, "OVERTIME") %>'></asp:CheckBox>
          </EditItemTemplate>
 		</asp:TemplateColumn>
		<asp:EditCommandColumn ButtonType="PushButton" EditText="Update" CancelText="Cancel" UpdateText="Update" ItemStyle-Wrap="false"/>
		<asp:ButtonColumn ButtonType="PushButton" Text="Delete" CommandName="Delete"/>
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
    			<td class="header">ADD AN ACTIVITY DURATION</td>
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
				<td width="50" class="text" align="left">Value : </td>
				<td width="5"></td>
				<td width="100"><input name="ValueTextField" type="text" class="text" id="ValueTextField" style="width:100px" maxlength="50" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="150" class="text" align="center">Duration in minutes : </td>
				<td width="5"></td>
				<td width="100"><input name="DurationTextField" type="text" class="text" id="DurationTextField" style="width:100px" maxlength="8" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="80" class="text" align="center">Overtime : </td>
				<td width="5"></td>
				<td width="60"><select id="OverTimeSelect" name="OverTimeSelect" size="1" class="text" style="width:60px"
										runat="server">
				  <option value="" selected></option>
			      <option value="1">Yes</option>
			      <option value="0">No</option>
			    </select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td align="center"><input type="submit" class="text" runat="server" style="width:100px" id="AddActivityDurationButton" name="AddActivityDurationButton" alt="Add an activity duration" value="Add" onServerClick="AddActivityDurationButton_Click"></td>
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