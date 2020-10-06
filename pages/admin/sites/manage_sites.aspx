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
<title>ADMINISTRATION - Manage sites</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			UpdateSiteDataGrid();
		}
	}
	
	void AddSiteButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if((NameTextField.Value == "")
		|| (UrlTextField.Value == ""))
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
						
					string result = sqlClient.ExecuteStoredProcedure("admin_add_site",
						"@name", GetValueFromHtmlInputText(NameTextField, true),
						"@url", GetValueFromHtmlInputText(UrlTextField, true));
						
					UpdateSiteDataGrid();
					InformationTextField.Value = result;
					NameTextField.Value = null;
					UrlTextField.Value = null;
				}
				catch(PortalSqlErrorException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while adding a site!&message=" + ex.Message);
				}
				catch(PortalSqlConstraintsException ex)
				{
					InformationTextField.Value = "WARNING : URL already exist!";
				}
			}
		}
	}
	
	void SiteDataGrid_Edit(Object sender, DataGridCommandEventArgs e)
    {
        SiteDataGrid.EditItemIndex = (int)e.Item.ItemIndex;
        UpdateSiteDataGrid();
    }

    void SiteDataGrid_Cancel(Object sender, DataGridCommandEventArgs e)
    {
        SiteDataGrid.EditItemIndex = -1;
        UpdateSiteDataGrid();
    }

    void SiteDataGrid_Update(Object sender, DataGridCommandEventArgs e)
    {
		InformationTextField.Value = null;

		if((((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditNameTextField")).Value == "")
		|| (((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditUrlTextField")).Value == ""))
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
						
					string result = sqlClient.ExecuteStoredProcedure("admin_update_site",
						"@id_site", SiteDataGrid.DataKeys[(int)e.Item.ItemIndex],
						"@name", GetValueFromHtmlInputText(((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditNameTextField")), true),
						"@url", GetValueFromHtmlInputText(((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditUrlTextField")), true));
				
					SiteDataGrid.EditItemIndex = -1;
					UpdateSiteDataGrid();
					InformationTextField.Value = result;
				}
				catch(PortalSqlErrorException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while updating a site!&message=" + ex.Message);
				}
				catch(PortalSqlConstraintsException ex)
				{
					InformationTextField.Value = "WARNING : URL already exist!";
				}
			}
		}
    }
	
	void SiteDataGrid_Delete(Object sender, DataGridCommandEventArgs e)
    {
		InformationTextField.Value = null;
		
        if(Session["sql_connection_string"] != null)
		{
			try
			{
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
					
				string result = sqlClient.ExecuteStoredProcedure("admin_delete_site",
					"@id_site", SiteDataGrid.DataKeys[(int)e.Item.ItemIndex]);
					
				UpdateSiteDataGrid();
				InformationTextField.Value = result;
			}
			catch(PortalException ex)
			{
				Response.Redirect("../../error/Default.aspx?error=Internal error while deleting a site!&message=" + ex.Message);
			}
		}
    }

	
	void UpdateSiteDataGrid()
    {
       	if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataGridWithStoredProcedure(ref SiteDataGrid, "admin_get_site_list");
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
    			<td class="header">MANAGE SITES</td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="SiteDataGrid" runat="server"
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
      OnEditCommand="SiteDataGrid_Edit"
      OnCancelCommand="SiteDataGrid_Cancel"
      OnUpdateCommand="SiteDataGrid_Update"
	  OnDeleteCommand="SiteDataGrid_Delete"
      DataKeyField="ID"
      AutoGenerateColumns="false"
    >

      <Columns>
        <asp:BoundColumn HeaderText="ID" Visible="false" SortExpression="ID" ReadOnly="True" DataField="ID" ItemStyle-Wrap="false"/>
        <asp:TemplateColumn HeaderText="NAME" HeaderStyle-Width="240" SortExpression="NAME">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'/>
          </ItemTemplate>
          <EditItemTemplate>
		  	<input id="EditNameTextField" name="EditNameTextField" type="text" class="text"  style="width:240px" maxlength="100" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'>
          </EditItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="URL" HeaderStyle-Width="400" SortExpression="URL">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "URL") %>'/>
          </ItemTemplate>
          <EditItemTemplate>
		  	<input id="EditUrlTextField" name="EditUrlTextField" type="text" class="text"  style="width:400px" maxlength="200" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "URL") %>'>
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
    			<td class="header">ADD A SITE</td>
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
				<td width="200"><input name="NameTextField" type="text" class="text" id="NameTextField" style="width:200px" maxlength="100" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="50" class="text" align="center">URL : </td>
				<td width="5"></td>
				<td width="400"><input name="UrlTextField" type="text" class="text" id="UrlTextField" style="width:400px" maxlength="200" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td align="center"><input type="submit" class="text" runat="server" style="width:100px" id="AddSiteButton" name="AddSiteButton" alt="Add a site" value="Add" onServerClick="AddSiteButton_Click"></td>
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