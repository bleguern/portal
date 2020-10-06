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
<title>ADMINISTRATION - Manage divisions</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			UpdateSectorDataGrid();
		}
	}
	
	void AddSectorButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if(NameTextField.Value == "")
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
						
					string result = sqlClient.ExecuteStoredProcedure("admin_add_sector",
						"@name", GetValueFromHtmlInputText(NameTextField, true));
						
					UpdateSectorDataGrid();
					InformationTextField.Value = result;
					NameTextField.Value = null;
				}
				catch(PortalSqlErrorException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while adding a division!&message=" + ex.Message);
				}
				catch(PortalSqlConstraintsException ex)
				{
					InformationTextField.Value = "WARNING : NAME already exist!";
				}
			}
		}
	}
	
	void SectorDataGrid_Edit(Object sender, DataGridCommandEventArgs e)
    {
        SectorDataGrid.EditItemIndex = (int)e.Item.ItemIndex;
        UpdateSectorDataGrid();
    }

    void SectorDataGrid_Cancel(Object sender, DataGridCommandEventArgs e)
    {
        SectorDataGrid.EditItemIndex = -1;
        UpdateSectorDataGrid();
    }

    void SectorDataGrid_Update(Object sender, DataGridCommandEventArgs e)
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
						
					string result = sqlClient.ExecuteStoredProcedure("admin_update_sector",
						"@id_sector", SectorDataGrid.DataKeys[(int)e.Item.ItemIndex],
						"@name", GetValueFromHtmlInputText(((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditNameTextField")), true));
				
					SectorDataGrid.EditItemIndex = -1;
					UpdateSectorDataGrid();
					InformationTextField.Value = result;
				}
				catch(PortalSqlErrorException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while updating a division!&message=" + ex.Message);
				}
				catch(PortalSqlConstraintsException ex)
				{
					InformationTextField.Value = "WARNING : NAME already exist!";
				}
			}
		}
    }
	
	void UpdateSectorDataGrid()
    {
       	if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataGridWithStoredProcedure(ref SectorDataGrid, "admin_get_sector_list");
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
    			<td class="header">MANAGE DIVISIONS </td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="SectorDataGrid" runat="server"
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
      OnEditCommand="SectorDataGrid_Edit"
      OnCancelCommand="SectorDataGrid_Cancel"
      OnUpdateCommand="SectorDataGrid_Update"
      DataKeyField="ID"
      AutoGenerateColumns="false"
    >

      <Columns>
        <asp:BoundColumn HeaderText="ID" Visible="false" SortExpression="ID" ReadOnly="True" DataField="ID" ItemStyle-Wrap="false"/>
        <asp:TemplateColumn HeaderText="NAME" HeaderStyle-Width="700" SortExpression="NAME">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'/>
          </ItemTemplate>
          <EditItemTemplate>
		  	<input id="EditNameTextField" name="EditNameTextField" type="text" class="text"  style="width:700px" maxlength="25" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'>
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
    			<td class="header">ADD A DIVISION </td>
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
				<td width="50" class="text" align="left">Name : </td>
				<td width="5"></td>
				<td width="600"><input name="NameTextField" type="text" class="text" id="NameTextField" style="width:600px" maxlength="25" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td align="center"><input type="submit" class="text" runat="server" style="width:100px" id="AddSectorButton" name="AddSectorButton" alt="Add a sector" value="Add" onServerClick="AddSectorButton_Click"></td>
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