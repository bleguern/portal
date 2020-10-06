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
<title>ADMINISTRATION - Manage non working days</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
<LINK href="../../../css/calendar.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../../scripts/calendar/CalendarPopup.js"></script>
<script type="text/javascript" src="../../../scripts/main.js"></script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			UpdateNonWorkingDaysDataGrid();
		}
	}
	
	void AddNonWorkingDayButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if((NameTextField.Value == "")
		|| (DateTextField.Value == ""))
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
						
					string result = sqlClient.ExecuteStoredProcedure("admin_add_non_working_day",
						"@date_time", GetValueFromHtmlInputText(DateTextField, true),
						"@name", GetValueFromHtmlInputText(NameTextField, true));
					
					UpdateNonWorkingDaysDataGrid();
					InformationTextField.Value = result;
					DateTextField.Value = null;
					NameTextField.Value = null;
				}
				catch(PortalSqlErrorException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while adding a non working day!&message=" + ex.Message);
				}
				catch(PortalSqlConstraintsException ex)
				{
					InformationTextField.Value = "WARNING : DATE already exist!";
				}
			}
		}
	}
	
	void NonWorkingDaysDataGrid_Edit(Object sender, DataGridCommandEventArgs e)
    {
        NonWorkingDaysDataGrid.EditItemIndex = (int)e.Item.ItemIndex;
        UpdateNonWorkingDaysDataGrid();
    }

    void NonWorkingDaysDataGrid_Cancel(Object sender, DataGridCommandEventArgs e)
    {
        NonWorkingDaysDataGrid.EditItemIndex = -1;
        UpdateNonWorkingDaysDataGrid();
    }

    void NonWorkingDaysDataGrid_Update(Object sender, DataGridCommandEventArgs e)
    {
		InformationTextField.Value = null;

		if(((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditNameTextField")).Value == "")
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
						
					string result = sqlClient.ExecuteStoredProcedure("admin_update_non_working_day",
						"@date_time", NonWorkingDaysDataGrid.DataKeys[(int)e.Item.ItemIndex],
						"@name", GetValueFromHtmlInputText(((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditNameTextField")), true));
					
					NonWorkingDaysDataGrid.EditItemIndex = -1;
					UpdateNonWorkingDaysDataGrid();
					InformationTextField.Value = result;
				}
				catch(PortalException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while updating a non working day!&message=" + ex.Message);
				}
			}
		}
    }
	
	void NonWorkingDaysDataGrid_Delete(Object sender, DataGridCommandEventArgs e)
    {
		InformationTextField.Value = null;
		
        if(Session["sql_connection_string"] != null)
		{
			try
			{
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
					
				string result = sqlClient.ExecuteStoredProcedure("admin_delete_non_working_day",
					"@date_time", NonWorkingDaysDataGrid.DataKeys[(int)e.Item.ItemIndex]);
					
				UpdateNonWorkingDaysDataGrid();
				InformationTextField.Value = result;
			}
			catch(PortalException ex)
			{
				Response.Redirect("../../error/Default.aspx?error=Internal error while deleting a non working day!&message=" + ex.Message);
			}
		}
    }
	
	void UpdateNonWorkingDaysDataGrid()
    {
       	if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataGridWithStoredProcedure(ref NonWorkingDaysDataGrid, "admin_get_non_working_day_list");
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
    			<td class="header">MANAGE NON WORKING DAYS</td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="NonWorkingDaysDataGrid" runat="server"
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
      OnEditCommand="NonWorkingDaysDataGrid_Edit"
      OnCancelCommand="NonWorkingDaysDataGrid_Cancel"
      OnUpdateCommand="NonWorkingDaysDataGrid_Update"
	  OnDeleteCommand="NonWorkingDaysDataGrid_Delete"
      DataKeyField="DATE"
      AutoGenerateColumns="false"
    >

      <Columns>
        <asp:BoundColumn HeaderText="DATE" ReadOnly="True" DataField="DATE" ItemStyle-Wrap="false"/>
        <asp:TemplateColumn HeaderText="NAME" HeaderStyle-Width="600" SortExpression="NAME">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'/>
          </ItemTemplate>
          <EditItemTemplate>
		  	<input id="EditNameTextField" name="EditNameTextField" type="text" class="text"  style="width:600px" maxlength="50" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'>
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
    			<td class="header">ADD A NON WORKING DAY</td>
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
				<td width="50" class="text" align="left">Date : </td>
				<td width="5"></td>
				<td width="80"><input name="DateTextField" type="text" class="text" id="DateTextField" style="width:80px" maxlength="10" runat="server"></td>
				<td width="18"><img id="DateImageLink" name="DateImageLink" src="../../../images/cal.gif" alt="Date" width="18" height="18" onClick="showCalendar(DateTextField, 'DateImageLink')"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="50" class="text" align="center">Name : </td>
				<td width="5"></td>
				<td width="400"><input name="NameTextField" type="text" class="text" id="NameTextField" style="width:400px" maxlength="50" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td align="center"><input type="submit" class="text" runat="server" style="width:100px" id="AddNonWorkingDayButton" name="AddNonWorkingDayButton" alt="Add a non working day" value="Add" onServerClick="AddNonWorkingDayButton_Click"></td>
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